<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * SPEC §6.2 服务端 Schema：全部 8 张表一次建全（含 M3 需要的好友/共享表）。
 *
 * 手工补充的部分（doctrine:migrations:diff 无法生成）：
 *  - CITEXT 扩展（email/username 大小写不敏感唯一）；
 *  - 枚举列的 CHECK 约束（DBAL 不做 CHECK 内省，不会产生 diff 噪音）；
 *  - friendship 的 LEAST/GREATEST 部分唯一索引（表达式索引，Doctrine
 *    属性无法表达；DBAL 内省会跳过表达式索引，不产生 diff 噪音）；
 *  - card_share 的部分唯一索引（实体上也用 UniqueConstraint(where) 声明，
 *    两边一致，schema:validate 干净）。
 */
final class Version20260707031600 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'SPEC §6.2 schema: user_account, auth_otp, refresh_token, device, card, friendship, card_share, user_card_state';
    }

    public function up(Schema $schema): void
    {
        // email/username 走 CITEXT（dev/test 的 postgres 镜像里 app 用户是超级用户；
        // 生产环境部署时需以足够权限预装该扩展，见 SPEC §10）
        $this->addSql('CREATE EXTENSION IF NOT EXISTS citext');

        $this->addSql('CREATE TABLE auth_otp (id UUID NOT NULL, email CITEXT NOT NULL, code_hash TEXT NOT NULL, expires_at TIMESTAMPTZ NOT NULL, attempts SMALLINT DEFAULT 0 NOT NULL, consumed_at TIMESTAMPTZ DEFAULT NULL, created_at TIMESTAMPTZ NOT NULL, PRIMARY KEY (id))');
        $this->addSql('CREATE TABLE card (id UUID NOT NULL, name TEXT NOT NULL, code_value TEXT NOT NULL, code_format TEXT NOT NULL, card_kind TEXT DEFAULT \'loyalty\' NOT NULL, color TEXT DEFAULT \'#4A6FA5\' NOT NULL, note TEXT DEFAULT NULL, expires_at DATE DEFAULT NULL, created_at TIMESTAMPTZ NOT NULL, updated_at TIMESTAMPTZ NOT NULL, deleted_at TIMESTAMPTZ DEFAULT NULL, owner_id UUID NOT NULL, PRIMARY KEY (id))');
        $this->addSql('CREATE INDEX IDX_161498D37E3C61F9 ON card (owner_id)');
        $this->addSql('CREATE INDEX idx_card_owner_updated_at ON card (owner_id, updated_at)');
        $this->addSql('CREATE TABLE card_share (id UUID NOT NULL, status TEXT NOT NULL, created_at TIMESTAMPTZ NOT NULL, updated_at TIMESTAMPTZ NOT NULL, deleted_at TIMESTAMPTZ DEFAULT NULL, card_id UUID NOT NULL, recipient_id UUID NOT NULL, PRIMARY KEY (id))');
        $this->addSql('CREATE INDEX IDX_D7326C9C4ACC9A20 ON card_share (card_id)');
        $this->addSql('CREATE INDEX IDX_D7326C9CE92F8F78 ON card_share (recipient_id)');
        $this->addSql('CREATE TABLE device (id UUID NOT NULL, platform TEXT NOT NULL, push_token TEXT NOT NULL, app_version TEXT NOT NULL, last_seen_at TIMESTAMPTZ NOT NULL, created_at TIMESTAMPTZ NOT NULL, user_id UUID NOT NULL, PRIMARY KEY (id))');
        $this->addSql('CREATE INDEX IDX_92FB68EA76ED395 ON device (user_id)');
        $this->addSql('CREATE TABLE friendship (id UUID NOT NULL, status TEXT NOT NULL, created_at TIMESTAMPTZ NOT NULL, updated_at TIMESTAMPTZ NOT NULL, deleted_at TIMESTAMPTZ DEFAULT NULL, requester_id UUID NOT NULL, addressee_id UUID NOT NULL, PRIMARY KEY (id))');
        $this->addSql('CREATE INDEX IDX_7234A45FED442CF4 ON friendship (requester_id)');
        $this->addSql('CREATE INDEX IDX_7234A45F2261B4C3 ON friendship (addressee_id)');
        $this->addSql('CREATE TABLE refresh_token (id UUID NOT NULL, token_hash TEXT NOT NULL, expires_at TIMESTAMPTZ NOT NULL, revoked_at TIMESTAMPTZ DEFAULT NULL, created_at TIMESTAMPTZ NOT NULL, user_id UUID NOT NULL, device_id UUID DEFAULT NULL, PRIMARY KEY (id))');
        $this->addSql('CREATE INDEX IDX_C74F2195A76ED395 ON refresh_token (user_id)');
        $this->addSql('CREATE INDEX IDX_C74F219594A4C7D4 ON refresh_token (device_id)');
        $this->addSql('CREATE TABLE user_account (id UUID NOT NULL, email CITEXT NOT NULL, username CITEXT NOT NULL, display_name TEXT NOT NULL, locale TEXT DEFAULT \'de\' NOT NULL, created_at TIMESTAMPTZ NOT NULL, updated_at TIMESTAMPTZ NOT NULL, PRIMARY KEY (id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_253B48AEE7927C74 ON user_account (email)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_253B48AEF85E0677 ON user_account (username)');
        $this->addSql('CREATE TABLE user_card_state (is_favorite BOOLEAN DEFAULT false NOT NULL, last_used_at TIMESTAMPTZ DEFAULT NULL, updated_at TIMESTAMPTZ NOT NULL, deleted_at TIMESTAMPTZ DEFAULT NULL, user_id UUID NOT NULL, card_id UUID NOT NULL, PRIMARY KEY (user_id, card_id))');
        $this->addSql('CREATE INDEX IDX_3CC0E5D1A76ED395 ON user_card_state (user_id)');
        $this->addSql('CREATE INDEX IDX_3CC0E5D14ACC9A20 ON user_card_state (card_id)');
        $this->addSql('ALTER TABLE card ADD CONSTRAINT FK_161498D37E3C61F9 FOREIGN KEY (owner_id) REFERENCES user_account (id) ON DELETE CASCADE NOT DEFERRABLE');
        $this->addSql('ALTER TABLE card_share ADD CONSTRAINT FK_D7326C9C4ACC9A20 FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE NOT DEFERRABLE');
        $this->addSql('ALTER TABLE card_share ADD CONSTRAINT FK_D7326C9CE92F8F78 FOREIGN KEY (recipient_id) REFERENCES user_account (id) ON DELETE CASCADE NOT DEFERRABLE');
        $this->addSql('ALTER TABLE device ADD CONSTRAINT FK_92FB68EA76ED395 FOREIGN KEY (user_id) REFERENCES user_account (id) ON DELETE CASCADE NOT DEFERRABLE');
        $this->addSql('ALTER TABLE friendship ADD CONSTRAINT FK_7234A45FED442CF4 FOREIGN KEY (requester_id) REFERENCES user_account (id) ON DELETE CASCADE NOT DEFERRABLE');
        $this->addSql('ALTER TABLE friendship ADD CONSTRAINT FK_7234A45F2261B4C3 FOREIGN KEY (addressee_id) REFERENCES user_account (id) ON DELETE CASCADE NOT DEFERRABLE');
        $this->addSql('ALTER TABLE refresh_token ADD CONSTRAINT FK_C74F2195A76ED395 FOREIGN KEY (user_id) REFERENCES user_account (id) ON DELETE CASCADE NOT DEFERRABLE');
        $this->addSql('ALTER TABLE refresh_token ADD CONSTRAINT FK_C74F219594A4C7D4 FOREIGN KEY (device_id) REFERENCES device (id) ON DELETE SET NULL NOT DEFERRABLE');
        $this->addSql('ALTER TABLE user_card_state ADD CONSTRAINT FK_3CC0E5D1A76ED395 FOREIGN KEY (user_id) REFERENCES user_account (id) ON DELETE CASCADE NOT DEFERRABLE');
        $this->addSql('ALTER TABLE user_card_state ADD CONSTRAINT FK_3CC0E5D14ACC9A20 FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE NOT DEFERRABLE');

        // 枚举列 CHECK 约束（SPEC §6.2；code_format 取值见 §3.1，与客户端 wire 值一致）
        $this->addSql("ALTER TABLE device ADD CONSTRAINT chk_device_platform CHECK (platform IN ('ios', 'android'))");
        $this->addSql("ALTER TABLE card ADD CONSTRAINT chk_card_kind CHECK (card_kind IN ('loyalty', 'coupon'))");
        $this->addSql("ALTER TABLE card ADD CONSTRAINT chk_card_code_format CHECK (code_format IN ('qr_code', 'aztec', 'data_matrix', 'pdf417', 'ean13', 'ean8', 'upc_a', 'upc_e', 'code128', 'code39', 'code93', 'itf', 'codabar'))");
        $this->addSql("ALTER TABLE friendship ADD CONSTRAINT chk_friendship_status CHECK (status IN ('pending', 'accepted', 'declined'))");
        $this->addSql("ALTER TABLE card_share ADD CONSTRAINT chk_card_share_status CHECK (status IN ('pending', 'accepted'))");

        // 部分唯一索引（SPEC §6.2）：
        // 每对用户至多一条活跃好友关系（单行双向，方向无关）
        $this->addSql('CREATE UNIQUE INDEX uniq_friendship_pair_active ON friendship (LEAST(requester_id, addressee_id), GREATEST(requester_id, addressee_id)) WHERE deleted_at IS NULL');
        // 同一张卡对同一接收者至多一条活跃共享；撤回（软删除）后可再次共享
        $this->addSql('CREATE UNIQUE INDEX uniq_card_share_active ON card_share (card_id, recipient_id) WHERE deleted_at IS NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE card DROP CONSTRAINT FK_161498D37E3C61F9');
        $this->addSql('ALTER TABLE card_share DROP CONSTRAINT FK_D7326C9C4ACC9A20');
        $this->addSql('ALTER TABLE card_share DROP CONSTRAINT FK_D7326C9CE92F8F78');
        $this->addSql('ALTER TABLE device DROP CONSTRAINT FK_92FB68EA76ED395');
        $this->addSql('ALTER TABLE friendship DROP CONSTRAINT FK_7234A45FED442CF4');
        $this->addSql('ALTER TABLE friendship DROP CONSTRAINT FK_7234A45F2261B4C3');
        $this->addSql('ALTER TABLE refresh_token DROP CONSTRAINT FK_C74F2195A76ED395');
        $this->addSql('ALTER TABLE refresh_token DROP CONSTRAINT FK_C74F219594A4C7D4');
        $this->addSql('ALTER TABLE user_card_state DROP CONSTRAINT FK_3CC0E5D1A76ED395');
        $this->addSql('ALTER TABLE user_card_state DROP CONSTRAINT FK_3CC0E5D14ACC9A20');
        $this->addSql('DROP TABLE auth_otp');
        $this->addSql('DROP TABLE card');
        $this->addSql('DROP TABLE card_share');
        $this->addSql('DROP TABLE device');
        $this->addSql('DROP TABLE friendship');
        $this->addSql('DROP TABLE refresh_token');
        $this->addSql('DROP TABLE user_account');
        $this->addSql('DROP TABLE user_card_state');
    }
}
