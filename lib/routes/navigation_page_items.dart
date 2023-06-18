//Main Page
const routeInkomen = 'inkomen';
const routeSchulden = 'schulden';
const routeHypotheek = 'hypotheek';
const routeBelasting = 'belasting';
const routeAflossen = 'aflossen';
const routeOverzicht = 'overzicht';

//Edit Page
const routeInkomenAanpassen = 'routeInkomenAanpassen';
const routeSchuldenSpecificatie = 'routeSchuldenSpecificatie';
const routeSchuldenBewerken = 'routeSchuldenAanpassen';
const routeHypotheekBewerken = 'routeHypotheekAanpassen';
const routeHypotheekDossierBewerken = 'routeHypotheekDossierAanpassen';

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
      id: routeInkomen, imageName: 'graphics/ic_money.png', title: 'Inkomen'),
  MortgageItems(
      id: routeSchulden, imageName: 'graphics/ic_debts.png', title: 'Schulden'),
  MortgageItems(
      id: routeHypotheek,
      imageName: 'graphics/ic_money_bag.png',
      title: 'Hypotheek'),
  MortgageItems(
      id: routeAflossen,
      imageName: 'graphics/ic_pay_off.png',
      title: 'Aflossen'),
  MortgageItems(
      id: routeBelasting,
      imageName: 'graphics/ic_belastingdienst.png',
      title: 'Belasting'),
  MortgageItems(
      id: routeOverzicht,
      imageName: 'graphics/ic_overview.png',
      title: 'Overzicht'),
];
