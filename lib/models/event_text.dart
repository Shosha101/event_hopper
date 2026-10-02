import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import 'event_model.dart';

/// The text of an event in one language.
class EventText {
  final String title;
  final String location;
  final String about;
  final String city;
  final String country;

  const EventText({
    required this.title,
    required this.location,
    required this.about,
    required this.city,
    required this.country,
  });
}

// Arabic text of the demo events (HiveService.addMockData), keyed by the English title.
// Events are stored once, in English; the Arabic interface shows this text instead.
const Map<String, EventText> _arabicEvents = {
  'Art Exhibition: "Masterpieces of the Modern World"': EventText(
    title: 'معرض فني: روائع العالم الحديث',
    location: 'معرض الفن الحديث، سان فرانسيسكو، الولايات المتحدة',
    about: 'استمتع بمجموعة مختارة من أرقى أعمال الفن المعاصر. يجمع هذا المعرض فنانين مجدّدين يرسمون ملامح مستقبل الثقافة البصرية. ستجد أعمالًا تركيبية تفاعلية، ومنحوتات تثير التفكير، ولوحات تتحدى الأفكار المألوفة. لكل عمل حكايته الخاصة، بين المدرسة التجريدية والمدرسة الواقعية.',
    city: 'سان فرانسيسكو',
    country: 'الولايات المتحدة',
  ),
  'Tech Conference 2024: "Innovation in AI and Beyond"': EventText(
    title: 'مؤتمر التقنية 2024: الابتكار في الذكاء الاصطناعي وما بعده',
    location: 'مركز مؤتمرات وادي السيليكون، سان خوسيه، الولايات المتحدة',
    about: 'انضم إلى هواة التقنية ورواد الأعمال وقادة الصناعة وهم يناقشون أحدث التطورات في الذكاء الاصطناعي وتعلّم الآلة وعلوم البيانات. يقدّم المؤتمر كلمات رئيسية لمتحدثين من كبرى الشركات، وورش عمل وجلسات حوارية. سواء كنت مبتدئًا أو خبيرًا، ستجد جلسات متعمقة في موضوعات مثل الحوسبة الكمّية والمركبات ذاتية القيادة وأخلاقيات الذكاء الاصطناعي.',
    city: 'سان خوسيه',
    country: 'الولايات المتحدة',
  ),
  'Drinks & Cocktail Festival 2024': EventText(
    title: 'مهرجان المشروبات والكوكتيلات 2024',
    location: 'القاعة الكبرى، شيكاغو، الولايات المتحدة',
    about: 'فعالية لا تفوَّت لعشاق الكوكتيلات ومحترفي تحضيرها وهواتها! تذوّق كوكتيلات حصرية يعدّها خبراء مشهورون عالميًا. شارك في ورش عن فن تحضير المشروبات، وتعرّف على أسرار المشروبات الكلاسيكية والحديثة، واكتشف أحدث اتجاهات صناعة المشروبات الروحية. يضم المهرجان أيضًا مصانع جعة حرفية محلية، وأركانًا لتذوّق النبيذ، وتشكيلة من المشروبات الخالية من الكحول للجميع.',
    city: 'شيكاغو',
    country: 'الولايات المتحدة',
  ),
  'Music Festival 2024: "The Sound of Tomorrow"': EventText(
    title: 'مهرجان الموسيقى 2024: صوت الغد',
    location: 'سنترال بارك، نيويورك، الولايات المتحدة',
    about: 'احتفال بالموسيقى من كل أنحاء العالم! تتنوع العروض بين الإيقاعات الإلكترونية والروك والإندي والهيب هوب والموسيقى الكلاسيكية المعاصرة، ويشارك في المهرجان فرق معروفة وفنانون صاعدون. تنقّل بين مسارح متعددة، واستمتع بالأجواء النابضة، وعش تجربة الموسيقى الحية كما لم تعشها من قبل. يستضيف المهرجان أيضًا عروضًا فنية تفاعلية وعروضًا راقصة وأطايب الطعام.',
    city: 'نيويورك',
    country: 'الولايات المتحدة',
  ),
  'International Sports Championship 2024': EventText(
    title: 'البطولة الرياضية الدولية 2024',
    location: 'الملعب الأولمبي، لندن، المملكة المتحدة',
    about: 'شاهد نخبة من أفضل رياضيي العالم يتنافسون في سلسلة من المنافسات المثيرة، منها ألعاب القوى والسباحة والجمباز والألعاب الجماعية. هذه البطولة حدث عالمي مرموق يجمع رياضيين من أنحاء العالم لاستعراض مهاراتهم وتحطيم الأرقام القياسية. استمتع بعروض رياضية متنوعة ومناطق للمشجعين وفرصة للقاء نجومك الرياضيين المفضلين.',
    city: 'لندن',
    country: 'المملكة المتحدة',
  ),
  'Technology Expo 2024: "The Future of Tech and Sustainability"': EventText(
    title: 'معرض التقنية 2024: مستقبل التقنية والاستدامة',
    location: 'مركز مؤتمرات لاس فيغاس، لاس فيغاس، الولايات المتحدة',
    about: 'اكتشف أحدث الابتكارات التقنية مع تركيز على الاستدامة. يجمع المعرض شركات ناشئة رائدة وشركات كبرى لعرض منتجات وحلول تُحدث فرقًا في كفاءة الطاقة والتقنيات المتجددة والمباني الخضراء والاستدامة المدعومة بالذكاء الاصطناعي. يمكن للحضور تجربة عروض حية، وحضور نقاشات عن مستقبل التقنية في حياتنا اليومية، والتواصل مع قادة الفكر في المجال.',
    city: 'لاس فيغاس',
    country: 'الولايات المتحدة',
  ),
};

extension LocalizedEvent on EventModel {
  /// Arabic text of the event, if it has a translation.
  EventText? get arabicText => _arabicEvents[title];

  /// The event's text in the app language. An event without a translation keeps its stored text.
  EventText text(BuildContext context) {
    final arabic = context.locale.languageCode == 'ar' ? arabicText : null;
    return arabic ??
        EventText(
          title: title,
          location: location,
          about: about,
          city: city,
          country: country,
        );
  }
}
