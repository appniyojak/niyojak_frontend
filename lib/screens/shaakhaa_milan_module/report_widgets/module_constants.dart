import '../../../helpers/static_data.dart' as Statics;

enum RankTab { upasthiti, naveenBharti, kaaryakram }

enum DurationTypes { today, yesterday, daily, weekly, monthly, quarterly, halfYearly, yearly }

extension DurationsFilter on DurationTypes {
  String get name {
    switch (this) {
      case DurationTypes.today:
        return Statics.getLabel('today', returnKey: true);
      case DurationTypes.yesterday:
        return Statics.getLabel('yesterday', returnKey: true);
      case DurationTypes.daily:
        return Statics.getLabel('daily', returnKey: true);
      case DurationTypes.weekly:
        return Statics.getLabel('weekly', returnKey: true);
      case DurationTypes.monthly:
        return Statics.getLabel('monthly', returnKey: true);
      case DurationTypes.quarterly:
        return Statics.getLabel('quarterly', returnKey: true);
      case DurationTypes.halfYearly:
        return Statics.getLabel('halfyearly', returnKey: true);
      case DurationTypes.yearly:
        return Statics.getLabel('yearly', returnKey: true);
    }
  }

  String get pastName {
    switch (this) {
      case DurationTypes.today:
        return Statics.getLabel('today', returnKey: true);
      case DurationTypes.yesterday:
        return Statics.getLabel('yesterday', returnKey: true);
      case DurationTypes.daily:
        return Statics.getLabel('daily', returnKey: true);
      case DurationTypes.weekly:
        return Statics.getLabel('weekly', returnKey: true);
      case DurationTypes.monthly:
        return Statics.getLabel('monthly', returnKey: true);
      case DurationTypes.quarterly:
        return Statics.getLabel('quarterly', returnKey: true);
      case DurationTypes.halfYearly:
        return Statics.getLabel('halfyearly', returnKey: true);
      case DurationTypes.yearly:
        return Statics.getLabel('yearly', returnKey: true);
    }
  }

  int get pkValues {
    switch (this) {
      case DurationTypes.today:
        return 0;
      case DurationTypes.yesterday:
        return 1;
      case DurationTypes.daily:
        return 1;
      case DurationTypes.weekly:
        return 7;
      case DurationTypes.monthly:
        return 30;
      case DurationTypes.quarterly:
        return 90;
      case DurationTypes.halfYearly:
        return 180;
      case DurationTypes.yearly:
        return 360;
    }
  }
}

extension RankTabFilter on RankTab {
  String get name {
    switch (this) {
      case RankTab.upasthiti:
        return "${Statics.getLabel('Total', returnKey: true)} ${Statics.getLabel('upastithi', returnKey: true)}";
      case RankTab.naveenBharti:
        return Statics.getLabel('newAdmission', returnKey: true);
      case RankTab.kaaryakram:
        return Statics.getLabel('karyakramWiseSeq', returnKey: true);
    }
  }
}

// Fixed kname list — order matches screenshot dropdown
const List<MapEntry<String, String>> karyakramItems = [
  MapEntry('IsDoneUrdhvapad', 'Minimum5minutesUrdhvapad'),
  MapEntry('IsDoneDandaPrahaar', 'Minimum1minuteDandaPrahaar'),
  MapEntry('IsDoneSaanghikGeet', 'SaanghikGeet'),
  MapEntry('IsDoneAmrutaVachan', 'AmrutaVachan'),
  MapEntry('IsDoneSubhaashit', 'Subhaashit'),
  MapEntry('IsDoneDeepBreathing', 'Minimum5minutesDeepBreathing'),
  MapEntry('IsDoneSooryaNamaskaar', 'Minimum5minutesSooryaNamaskaar'),
  MapEntry('IsDoneSanchalanAbhyaas', 'Minimum5minutesSanchalanAbhyaas'),
  MapEntry('IsDoneBoodhKatha', 'BoodhKathaOnceWeek'),
  MapEntry('IsDoneBoudhikDays', 'BoudhikDays'),
  MapEntry('IsDoneSewaDays', 'SewaDays'),
  MapEntry('IsOptionalShaaririk', 'ConductedOptionalShaaririkVishay'),
  MapEntry('IsOptionalOther', 'ConductedOtherOptionalKaaryakram'),
];
