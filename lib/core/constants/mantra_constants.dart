class DeityInfo {
  const DeityInfo({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.nameGu,
    required this.greetingEn,
    required this.greetingHi,
    required this.greetingGu,
    required this.symbol,
  });

  final String id;
  final String nameEn;
  final String nameHi;
  final String nameGu;
  final String greetingEn;
  final String greetingHi;
  final String greetingGu;
  final String symbol;

  String nameFor(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return nameHi;
      case 'gu':
        return nameGu;
      default:
        return nameEn;
    }
  }

  String greetingFor(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return greetingHi;
      case 'gu':
        return greetingGu;
      default:
        return greetingEn;
    }
  }
}

class SeedMantra {
  const SeedMantra({
    required this.id,
    required this.name,
    required this.text,
    required this.transliteration,
    required this.deityId,
    this.target = 108,
  });

  final String id;
  final String name;
  final String text;
  final String transliteration;
  final String deityId;
  final int target;
}

/// Guru / murti focus list + seed mantras (Swaminarayan-only).
class MantraConstants {
  MantraConstants._();

  static const List<DeityInfo> deities = [
    DeityInfo(
      id: 'swaminarayan',
      nameEn: 'Bhagwan Shri Swaminarayan',
      nameHi: 'भगवान श्री स्वामिनारायण',
      nameGu: 'ભગવાન શ્રી સ્વામિનારાયણ',
      greetingEn: 'Jai Swaminarayan',
      greetingHi: 'जय स्वामिनारायण',
      greetingGu: 'જય સ્વામિનારાયણ',
      symbol: '॥',
    ),
    DeityInfo(
      id: 'gunatitanand',
      nameEn: 'Aksharbrahma Gunatitanand Swami',
      nameHi: 'अक्षरब्रह्म गुणातीतानंद स्वामी',
      nameGu: 'અક્ષરબ્રહ્મ ગુણાતીતાનંદ સ્વામી',
      greetingEn: 'Jai Swaminarayan',
      greetingHi: 'जय स्वामिनारायण',
      greetingGu: 'જય સ્વામિનારાયણ',
      symbol: '🪷',
    ),
    DeityInfo(
      id: 'bhagatji',
      nameEn: 'Bhagatji Maharaj',
      nameHi: 'भगतजी महाराज',
      nameGu: 'ભગતજી મહારાજ',
      greetingEn: 'Jai Swaminarayan',
      greetingHi: 'जय स्वामिनारायण',
      greetingGu: 'જય સ્વામિનારાયણ',
      symbol: '॥',
    ),
    DeityInfo(
      id: 'shastriji',
      nameEn: 'Shastriji Maharaj',
      nameHi: 'शास्त्रीजी महाराज',
      nameGu: 'શાસ્ત્રીજી મહારાજ',
      greetingEn: 'Jai Swaminarayan',
      greetingHi: 'जय स्वामिनारायण',
      greetingGu: 'જય સ્વામિનારાયણ',
      symbol: '🛕',
    ),
    DeityInfo(
      id: 'yogiji',
      nameEn: 'Yogiji Maharaj',
      nameHi: 'योगीजी महाराज',
      nameGu: 'યોગીજી મહારાજ',
      greetingEn: 'Jai Swaminarayan',
      greetingHi: 'जय स्वामिनारायण',
      greetingGu: 'જય સ્વામિનારાયણ',
      symbol: '🪷',
    ),
    DeityInfo(
      id: 'pramukh_swami',
      nameEn: 'Pramukh Swami Maharaj',
      nameHi: 'प्रमुख स्वामी महाराज',
      nameGu: 'પ્રમુખ સ્વામી મહારાજ',
      greetingEn: 'Jai Swaminarayan',
      greetingHi: 'जय स्वामिनारायण',
      greetingGu: 'જય સ્વામિનારાયણ',
      symbol: '॥',
    ),
    DeityInfo(
      id: 'mahant_swami',
      nameEn: 'Mahant Swami Maharaj',
      nameHi: 'महंत स्वामी महाराज',
      nameGu: 'મહંત સ્વામી મહારાજ',
      greetingEn: 'Jai Swaminarayan',
      greetingHi: 'जय स्वामिनारायण',
      greetingGu: 'જય સ્વામિનારાયણ',
      symbol: '॥',
    ),
  ];

  static const List<SeedMantra> seedMantras = [
    SeedMantra(
      id: 'mantra_swaminarayan',
      name: 'Swaminarayan',
      text: 'श्री स्वामिनारायण',
      transliteration: 'Shri Swaminarayan',
      deityId: 'swaminarayan',
    ),
    SeedMantra(
      id: 'mantra_jai_swaminarayan',
      name: 'Jai Swaminarayan',
      text: 'जय स्वामिनारायण',
      transliteration: 'Jai Swaminarayan',
      deityId: 'swaminarayan',
    ),
    SeedMantra(
      id: 'mantra_om_swaminarayanaya',
      name: 'Om Shri Swaminarayanaya Namah',
      text: 'ॐ श्री स्वामिनारायणाय नमः',
      transliteration: 'Om Shri Swaminarayanaya Namah',
      deityId: 'swaminarayan',
    ),
    SeedMantra(
      id: 'mantra_sahajanand',
      name: 'Sahajanand',
      text: 'श्री सहजानंद',
      transliteration: 'Shri Sahajanand',
      deityId: 'swaminarayan',
    ),
    SeedMantra(
      id: 'mantra_nilkanth',
      name: 'Nilkanth Varni',
      text: 'नीलकंठ वर्णी',
      transliteration: 'Nilkanth Varni',
      deityId: 'swaminarayan',
    ),
    SeedMantra(
      id: 'mantra_gunatit',
      name: 'Gunatit Smruti',
      text: 'गुणातीत',
      transliteration: 'Gunatit',
      deityId: 'gunatitanand',
    ),
    SeedMantra(
      id: 'mantra_akshar_purushottam',
      name: 'Akshar-Purushottam',
      text: 'अक्षर-पुरुषोत्तम',
      transliteration: 'Akshar-Purushottam',
      deityId: 'shastriji',
    ),
    SeedMantra(
      id: 'mantra_pramukh_joy',
      name: 'Joy of Others',
      text: 'पर की खुशी में',
      transliteration: 'Par Ki Khushi Mein',
      deityId: 'pramukh_swami',
    ),
    SeedMantra(
      id: 'mantra_mahant_shanti',
      name: 'Shanti Smruti',
      text: 'शांति',
      transliteration: 'Shanti',
      deityId: 'mahant_swami',
    ),
    SeedMantra(
      id: 'mantra_namavali_path',
      name: 'Sahajanand Namavali Path',
      text: 'सहजानंद नामावली पथ',
      transliteration: 'Sahajanand Namavali Path',
      deityId: 'swaminarayan',
    ),
  ];

  static DeityInfo? deityById(String id) {
    try {
      return deities.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  static const List<String> categories = [
    'swaminarayan',
    'gunatit',
    'namavali',
    'sadhana',
    'custom',
  ];
}
