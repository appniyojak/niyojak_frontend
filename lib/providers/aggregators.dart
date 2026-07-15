import '../models/response_model/home_screen_main_data_resp_model.dart';

/// Pure, stateless helpers that transform raw [HomeScreenData] lists into
/// UI-ready lists with an appended "Total" row.
///
/// This logic used to live inline inside the network-call function, mutating
/// global variables as a side effect. It's pulled out here so that:
///   - it can be unit tested with a plain [HomeScreenData] instance and no
///     Flutter / network / Provider dependency,
///   - [DashboardProvider] stays focused on state management only,
///   - adding/False the exact same list-plus-total-row pattern for a new
///     table is a one-line addition instead of copy-pasted loop boilerplate.
class DashboardAggregations {
  DashboardAggregations._();

  static int _sum<T>(List<T> items, int? Function(T item) selector) {
    return items.fold<int>(0, (sum, item) => sum + (selector(item) ?? 0));
  }

  // ---------------------------------------------------------------------
  // Shaakhaa count by Vayogat (age group)
  // ---------------------------------------------------------------------
  static List<ListShaakhaaCountByVayogat> shaakhaaCountByVayogatWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listShaakhaaCountByVayogat ?? [];
    if (items.isEmpty) return [];

    final total = ListShaakhaaCountByVayogat(
      vayogatID: -1,
      vayogatCode: totalLabel,
      shaakhaaCount: _sum(items, (e) => e.shaakhaaCount),
      sanghaMandaliCount: _sum(items, (e) => e.sanghaMandaliCount),
      saaptaahikCount: _sum(items, (e) => e.saaptaahikCount),
      maasikMilanCount: _sum(items, (e) => e.maasikMilanCount),
      sankalpitShaakhaaCount: _sum(items, (e) => e.sankalpitShaakhaaCount),
      sankalpitSaaptaahikCount: _sum(items, (e) => e.sankalpitSaaptaahikCount),
      sankalpitMaasikMilanCount: _sum(items, (e) => e.sankalpitMaasikMilanCount),
      sankalpitSanghaMandaliCount: _sum(items, (e) => e.sankalpitSanghaMandaliCount),
    );

    return [...items, total];
  }

  // ---------------------------------------------------------------------
  // Kaaryakartaa count by Gatividhi / Aayaam
  // ---------------------------------------------------------------------
  static List<ListKaaryakartaaCountByGatividhi> kaaryakartaaByGatividhiWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listKaaryakartaaCountByGatividhi ?? [];
    if (items.isEmpty) return [];

    final total = ListKaaryakartaaCountByGatividhi(
      gatividhiID: 0,
      gatividhiName: totalLabel,
      kaaryakartaaCount: _sum(items, (e) => e.kaaryakartaaCount),
    );
    return [...items, total];
  }

  static List<ListKaaryakartaaCountByAayaam> kaaryakartaaByAayaamWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listKaaryakartaaCountByAayaam ?? [];
    if (items.isEmpty) return [];

    final total = ListKaaryakartaaCountByAayaam(
      aayaamID: 0,
      aayaamName: totalLabel,
      kaaryakartaaCount: _sum(items, (e) => e.kaaryakartaaCount),
    );
    return [...items, total];
  }

  // ---------------------------------------------------------------------
  // Kaaryakartaa count by area of operation (Sangha-prerit sanstha / Social org)
  // ---------------------------------------------------------------------
  static List<ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation> preritSansthaaKaaryakartaaWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation ?? [];
    if (items.isEmpty) return [];

    final total = ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation(
      areaOfOperationID: 0,
      areaOfOperation: totalLabel,
      kaaryakartaaCount: _sum(items, (e) => e.kaaryakartaaCount),
    );
    return [...items, total];
  }

  static List<ListSocialOrganizationKaaryakartaaCountByAreaOfOperation> socialOrgKaaryakartaaWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listSocialOrganizationKaaryakartaaCountByAreaOfOperation ?? [];
    if (items.isEmpty) return [];

    final total = ListSocialOrganizationKaaryakartaaCountByAreaOfOperation(
      mainAreaOfOperationID: 0,
      areaOfOperation: totalLabel,
      kaaryakartaaCount: _sum(items, (e) => e.kaaryakartaaCount),
    );
    return [...items, total];
  }

  // ---------------------------------------------------------------------
  // Student / Vyavasaayee category counts
  // ---------------------------------------------------------------------
  static List<ListSwayamsevakCountByStudentCategory> studentCategoryWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listSwayamsevakCountByStudentCategory ?? [];
    if (items.isEmpty) return [];

    final total = ListSwayamsevakCountByStudentCategory(
      studentCategoryID: 0,
      studentCategoryName: totalLabel,
      countByStudentCategory: _sum(items, (e) => e.countByStudentCategory),
    );
    return [...items, total];
  }

  static List<ListSwayamsevakCountByVyavasaayeeCategory> vyavasaayeeCategoryWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listSwayamsevakCountByVyavasaayeeCategory ?? [];
    if (items.isEmpty) return [];

    final total = ListSwayamsevakCountByVyavasaayeeCategory(
      vyavasaayeeCategoryID: 0,
      vyavasaayeeCategoryName: totalLabel,
      countByVyavasaayeeCategory: _sum(items, (e) => e.countByVyavasaayeeCategory),
    );
    return [...items, total];
  }

  // ---------------------------------------------------------------------
  // Yesterday's Vrutta (activity report) — detail and summary
  // ---------------------------------------------------------------------
  static List<ListYesterdayVrutta> yesterdayVruttaDetailWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listYesterdayVrutta ?? [];
    if (items.isEmpty) return [];

    final total = ListYesterdayVrutta(
      geoUnitID: 0,
      shaakhaaID: 0,
      geoUnitName: totalLabel,
      frequencyID: 0,
      frequencyCode: '',
      vayogatID: 0,
      vayogatCode: '',
      shishuCount: _sum(items, (e) => e.shishuCount),
      baalVidyaarthiCount: _sum(items, (e) => e.baalVidyaarthiCount),
      tarunVidyaarthiCount: _sum(items, (e) => e.tarunVidyaarthiCount),
      tarunVyavasaayeeCount: _sum(items, (e) => e.tarunVyavasaayeeCount),
      proudhaVyavasaayeeCount: _sum(items, (e) => e.proudhaVyavasaayeeCount),
      abhyaagatCount: _sum(items, (e) => e.abhyaagatCount),
    );
    return [...items, total];
  }

  static List<ListYesterdayVruttaSummary> yesterdayVruttaSummaryWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listYesterdayVruttaSummary ?? [];
    if (items.isEmpty) return [];

    final total = ListYesterdayVruttaSummary(
      geoUnitID: 0,
      geoUnitName: totalLabel,
      vayogatID: 0,
      vayogatCode: '',
      shaakhaaCount: _sum(items, (e) => e.shaakhaaCount),
      saaptaahikCount: _sum(items, (e) => e.saaptaahikCount),
      milanMandaliCount: _sum(items, (e) => e.milanMandaliCount),
    );
    return [...items, total];
  }

  static List<ListYesterdayPraantShaakhaaCountByVayogat> yesterdayPraantWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listYesterdayPraantShaakhaaCountByVayogat ?? [];
    if (items.isEmpty) return [];

    // Note: MaasikMilanCount / SanghaMandaliCount / all Sankalpit* fields are
    // typed as always-null for this particular report (per the API/model),
    // so only ShaakhaaCount and SaaptaahikCount are meaningful to total.
    final total = ListYesterdayPraantShaakhaaCountByVayogat(
      vayogatID: 0,
      vayogatCode: totalLabel,
      shaakhaaCount: _sum(items, (e) => e.shaakhaaCount),
      saaptaahikCount: _sum(items, (e) => e.saaptaahikCount),
    );
    return [...items, total];
  }

  // ---------------------------------------------------------------------
  // Sankalp (pledge) by Aadhaar
  // ---------------------------------------------------------------------
  /// Mirrors the original behaviour: rows where both the pledged Shaakhaa
  /// and Saaptaahik counts are zero are hidden from the table, but they are
  /// still folded into the Total row.
  static List<ListSankalpByAadhaar> sankalpByAadhaarWithTotal(
    HomeScreenData data, {
    String totalLabel = 'Total',
  }) {
    final items = data.listSankalpByAadhaar ?? [];
    if (items.isEmpty) return [];

    final total = ListSankalpByAadhaar(
      vayogatID: 0,
      vayogatCode: totalLabel,
      sankalpAadhaar: '',
      sankalpitShaakhaaCount: _sum(items, (e) => e.sankalpitShaakhaaCount),
      sankalpitSaaptaahikCount: _sum(items, (e) => e.sankalpitSaaptaahikCount),
      sankalpitMasikMilankCount: _sum(items, (e) => e.sankalpitMasikMilankCount),
      sankalpitSanghaMandalikCount: _sum(items, (e) => e.sankalpitSanghaMandalikCount),
    );

    final visibleRows = items.where(
      (e) => (e.sankalpitShaakhaaCount ?? 0) != 0 || (e.sankalpitSaaptaahikCount ?? 0) != 0,
    );

    return [...visibleRows, total];
  }

  // ---------------------------------------------------------------------
  // Geographic spread (Bhaugolik Vistaar)
  // ---------------------------------------------------------------------
  /// Reshapes the flat [BhaugolikVistaarData] object into a list of rows,
  /// one per geo-unit type, skipping any type whose total count is zero.
  static List<BhaugolikVistaarRow> bhaugolikVistaarRows(BhaugolikVistaarData v) {
    final candidates = <BhaugolikVistaarRow>[
      BhaugolikVistaarRow(
        label: 'Nagar',
        total: v.totalNagarCount ?? 0,
        shaakhaaYukta: v.shaakhaaYuktaNagarCount,
        saaptaahikYukta: v.saaptaahikYuktaNagarCount,
        mandaliYukta: v.mandaliYuktaNagarCount,
        gatividhiYukta: v.gatividhiYuktaNagarCount,
      ),
      BhaugolikVistaarRow(
        label: 'NagarGraamin',
        total: v.totalNagarCountGraamin ?? 0,
        shaakhaaYukta: v.shaakhaaYuktaNagarCountGraamin,
        saaptaahikYukta: v.saaptaahikYuktaNagarCountGraamin,
        mandaliYukta: v.mandaliYuktaNagarCountGraamin,
        gatividhiYukta: v.gatividhiYuktaNagarCountGraamin,
      ),
      BhaugolikVistaarRow(
        label: 'NagarShahari',
        total: v.totalNagarCountShahari ?? 0,
        shaakhaaYukta: v.shaakhaaYuktaNagarCountShahari,
        saaptaahikYukta: v.saaptaahikYuktaNagarCountShahari,
        mandaliYukta: v.mandaliYuktaNagarCountShahari,
        gatividhiYukta: v.gatividhiYuktaNagarCountShahari,
      ),
      BhaugolikVistaarRow(
        label: 'Mandal',
        total: v.totalMandalCount ?? 0,
        shaakhaaYukta: v.shaakhaaYuktaMandalCount,
        saaptaahikYukta: v.saaptaahikYuktaMandalCount,
        mandaliYukta: v.mandaliYuktaMandalCount,
        gatividhiYukta: v.gatividhiYuktaMandalCount,
      ),
      BhaugolikVistaarRow(
        label: 'Graam',
        total: v.totalGraamCount ?? 0,
        shaakhaaYukta: v.shaakhaaYuktaGraamCount,
        saaptaahikYukta: v.saaptaahikYuktaGraamCount,
        mandaliYukta: v.mandaliYuktaGraamCount,
        gatividhiYukta: v.gatividhiYuktaGraamCount,
      ),
      BhaugolikVistaarRow(
        label: 'Vasti',
        total: v.totalVastiCount ?? 0,
        shaakhaaYukta: v.shaakhaaYuktaVastiCount,
        saaptaahikYukta: v.saaptaahikYuktaVastiCount,
        mandaliYukta: v.mandaliYuktaVastiCount,
        gatividhiYukta: v.gatividhiYuktaVastiCount,
      ),
      // 'Shahar' intentionally omitted — the original code kept it
      // commented out. Add it back the same way if it's needed later.
    ];

    return candidates.where((row) => row.total > 0).toList();
  }
}
