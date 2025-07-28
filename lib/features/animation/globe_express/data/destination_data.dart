
class Destination {
  final String imageUrl;
  final String region;
  final String name;
  final String description; // Added description for hero section

  Destination({
    required this.imageUrl,
    required this.region,
    required this.name,
    required this.description,
  });
}

final List<Destination> destinations = [
  Destination(
    imageUrl: 'assets/images/website/mountain-biker.jpg', // Default background
    region: 'Switzerland Alps',
    name: 'SAINT\nANTÖNIEN',
    description: 'Mauris malesuada nisl sit amet augue accumsan tincidunt. Maecenas tincidunt, velit at porttitor pulvinar, tortor eros facilisis lorem.',
  ),
  Destination(
    imageUrl: 'assets/images/website/japanese-macaque.jpg',
    region: 'Japan Alps',
    name: 'NAGANO\nPREFECTURE',
    description: 'Discover the stunning landscapes and unique culture of Nagano, famous for its snow monkeys and beautiful mountains.',
  ),
  Destination(
    imageUrl: 'assets/images/website/sahara-desert.jpg',
    region: 'Sahara Desert - Morocco',
    name: 'MARRAKECH\nMERZOUGA',
    description: 'Experience the magic of the Sahara Desert with camel treks and breathtaking sunsets in the dunes of Merzouga.',
  ),
  Destination(
    imageUrl: 'assets/images/website/yosemite-climber.jpg',
    region: 'Sierra Nevada - United States',
    name: 'YOSEMITE\nNATIONAL PARK',
    description: 'Explore the iconic granite cliffs, giant sequoia groves, and stunning waterfalls of Yosemite National Park.',
  ),
  Destination(
    imageUrl: 'assets/images/website/kitesurfing-beach.jpg',
    region: 'Tarifa - Spain',
    name: 'LOS LANCES\nBEACH',
    description: 'Feel the thrill of kitesurfing on the windy beaches of Tarifa, a paradise for water sports enthusiasts.',
  ),
];