List<Challenge> challenges = [
  Challenge(
    id: 1,
    title: "Bez butelki PET",
    description:
        "Jeśli dziś nie używałeś jednorazowej plastikowej butelki, gratulacje! Dzięki temu pomagasz zmniejszyć ilość plastiku w środowisku i chronisz naszą planetę.",
    tags: [],
    points: 1,
    bonus: 30,
  ),
  Challenge(
    id: 2,
    title: "Nie jedzenie Mięsa",
    description:
        "Produkcja mięsa mocno obciąża środowisko – spróbuj ograniczyć jego spożycie lub wyeliminować je całkowicie. To mały krok, który może zrobić dużą różnicę dla planety!",
    tags: ["not-vege"],
    points: 2,
    bonus: 14,
  ),
  Challenge(
    id: 3,
    title: "Nie używanie Suszarki",
    description:
        "Pozwól włosom wyschnąć naturalnie, to zdrowsze dla nich i pomaga oszczędzać energię, którą zużywa suszarka.",
    tags: [],
    points: 1,
    bonus: 45,
  ),
  Challenge(
    id: 4,
    title: "Wypięcie z sieci",
    description:
        "Odłączaj urządzenia z gniazdek – nawet wyłączone, nadal zużywają energię. To prosty sposób na oszczędzanie prądu i ochronę środowiska!",
    tags: [],
    points: 1,
    bonus: 21,
  ),
  Challenge(
    id: 5,
    title: "Wspólna jazda",
    description:
        "Podróżuj wspólnie – im więcej osób w samochodzie, tym mniejszy ślad węglowy przypadający na każdego pasażera. To oszczędność paliwa i korzyść dla planety!",
    tags: ["car"],
    points: 3,
    bonus: 7,
  ),
  Challenge(
    id: 6,
    title: "Wyłącz klimatyzację",
    description:
        "Zamiast tego przewietrz pomieszczenie lub ubierz się odpowiednio do temperatury. To prosty sposób na oszczędność energii i wsparcie dla środowiska!",
    tags: ["ac"],
    points: 1,
    bonus: 30,
  )
];

class Challenge {
  final int id;
  final String title;
  final String description;
  final List<String> tags;
  final int points;
  final int bonus;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.points,
    required this.bonus,
  });
}
