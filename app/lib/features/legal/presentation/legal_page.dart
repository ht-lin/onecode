import 'package:flutter/material.dart';

/// 法务页正文的一个段落：小标题 + 正文。
class LegalSection {
  const LegalSection(this.heading, this.body);

  final String heading;
  final String body;
}

/// Impressum 占位（DDG §5，SPEC §9.3）。
///
/// TODO(M4-02): 用定稿文本替换全部 [占位] 字段，并补英文版。
/// 法定内容为德语原文，不走 l10n。
const impressumSections = [
  LegalSection(
    'Anbieter',
    '[Vorname Nachname]\n[Straße Hausnummer]\n[PLZ Ort]\nDeutschland',
  ),
  LegalSection(
    'Kontakt',
    'E-Mail: [kontakt@example.org]',
  ),
  LegalSection(
    'Verantwortlich für den Inhalt',
    '[Vorname Nachname], Anschrift wie oben.',
  ),
  LegalSection(
    'EU-Streitschlichtung',
    'Die Europäische Kommission stellt eine Plattform zur '
        'Online-Streitbeilegung (OS) bereit: https://ec.europa.eu/consumers/odr/. '
        'Zur Teilnahme an einem Streitbeilegungsverfahren vor einer '
        'Verbraucherschlichtungsstelle sind wir nicht verpflichtet und nicht bereit.',
  ),
];

/// Datenschutzerklärung 占位（DSGVO，SPEC §9）。
///
/// TODO(M4-02): 用定稿文本替换（含处理者清单：Hetzner、SMTP、Google Ireland/FCM），
/// 并补英文版。法定内容为德语原文，不走 l10n。
const privacySections = [
  LegalSection(
    'Verantwortlicher',
    '[Vorname Nachname]\n[Straße Hausnummer]\n[PLZ Ort]\n'
        'E-Mail: [kontakt@example.org]',
  ),
  LegalSection(
    'Verarbeitung ohne Konto',
    'Ohne Konto werden alle Karten ausschließlich lokal auf Ihrem Gerät '
        'gespeichert. Es werden keine personenbezogenen Daten an unsere '
        'Server übertragen.',
  ),
  LegalSection(
    'Verarbeitung mit Konto',
    '[Platzhalter: E-Mail-Adresse, Kartendaten, Freundschafts- und '
        'Sharing-Beziehungen, Push-Token — Zwecke und Rechtsgrundlagen '
        'nach Art. 6 Abs. 1 lit. b DSGVO.]',
  ),
  LegalSection(
    'Auftragsverarbeiter',
    '[Platzhalter: Hetzner Online GmbH (Hosting, Deutschland), '
        'SMTP-Dienstleister (EU), Google Ireland Ltd. (nur FCM-Kanal).]',
  ),
  LegalSection(
    'Speicherdauer',
    '[Platzhalter: Serverzugriffslogs 14 Tage; Kontodaten bis zur Löschung '
        'des Kontos, vollständige Löschung binnen 72 Stunden.]',
  ),
  LegalSection(
    'Ihre Rechte',
    'Sie haben das Recht auf Auskunft (Art. 15 DSGVO), Berichtigung '
        '(Art. 16), Löschung (Art. 17), Einschränkung (Art. 18), '
        'Datenübertragbarkeit (Art. 20) und Widerspruch (Art. 21) sowie ein '
        'Beschwerderecht bei einer Aufsichtsbehörde (Art. 77). Konto-Export '
        'und -Löschung stehen direkt in der App zur Verfügung.',
  ),
];

/// 法务页骨架（SPEC §9.3）：从设置进入，渲染结构化段落。
class LegalPage extends StatelessWidget {
  const LegalPage({super.key, required this.title, required this.sections});

  final String title;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final section in sections) ...[
            Text(section.heading, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(section.body, style: textTheme.bodyMedium),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
