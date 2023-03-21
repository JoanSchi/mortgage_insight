const routeMobile = 'routeMobile';

class DifferentRoutes {
  final String mobile;
  final String large;
  final String item;

  const DifferentRoutes(
    this.item, {
    this.mobile = '',
    this.large = '',
  });
}

//Main Page
const routeIncome = 'routeIncome_Page';
const routeDebts = 'routeDebts_Page';
const routeMortgage = 'routeMortgage_Page';
const routeTax = 'routeTax_Page';
const routePayoff = 'routePayoff_Page';
const routeOverview = 'routeOverview_nPage';
const routeTable = 'routeTable_Page';
const routeGraph = 'routeGraph_Page';

//Edit Page
const routeIncomeEdit = 'routeIncomeEdit';
const routeDebtsAdd = 'routeDebtsAdd';
const routeDebtsEdit = 'routeDebtsEdit';
const routeMortgageEdit = 'routeMortgageEdit';
const routeHypotheekDossierEdit = 'routeNieweHypotheekProfielEdit';

class MortgageItems {
  final String imageName;
  final String title;
  final String id;

  const MortgageItems({
    required this.imageName,
    required this.title,
    required this.id,
  });
}

const List<MortgageItems> mortgageItemsList = [
  MortgageItems(
      id: routeIncome, imageName: 'graphics/ic_money.png', title: 'Inkomen'),
  MortgageItems(
      id: routeDebts, imageName: 'graphics/ic_debts.png', title: 'Schulden'),
  MortgageItems(
      id: routeMortgage,
      imageName: 'graphics/ic_money_bag.png',
      title: 'Hypotheek'),
  MortgageItems(
      id: routePayoff, imageName: 'graphics/ic_pay_off.png', title: 'Aflossen'),
  MortgageItems(
      id: routeTax,
      imageName: 'graphics/ic_belastingdienst.png',
      title: 'Belasting'),
  MortgageItems(
      id: routeOverview,
      imageName: 'graphics/ic_overview.png',
      title: 'Overzicht'),
  MortgageItems(
      id: routeTable, imageName: 'graphics/ic_table.png', title: 'Tabel'),
  MortgageItems(
      id: routeGraph, imageName: 'graphics/ic_table.png', title: 'Graph'),
];
