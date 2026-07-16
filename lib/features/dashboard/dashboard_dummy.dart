class FeaturedDashboardItem {
  const FeaturedDashboardItem({
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  final String buttonText;
  final String subtitle;
  final String title;
}

class PopularCourseItem {
  const PopularCourseItem({
    required this.author,
    required this.category,
    required this.date,
    required this.title,
    this.imageUrl,
  });

  final String author;
  final String category;
  final String date;
  final String? imageUrl;
  final String title;
}

const dashboardCategories = [
  'UI/UX',
  'Backend',
  'Flutter',
  'Laravel',
  'Database',
  'PHP',
];

const featuredDashboardItem = FeaturedDashboardItem(
  title: 'Learning Anywhere',
  subtitle: 'Improve your programming skill every day',
  buttonText: 'Explore',
);

const popularCourses = [
  PopularCourseItem(
    title: 'Laravel REST API',
    author: 'John Doe',
    category: 'Laravel',
    date: 'Today',
  ),
  PopularCourseItem(
    title: 'Flutter Mobile UI',
    author: 'Jane Smith',
    category: 'Flutter',
    date: 'Yesterday',
  ),
  PopularCourseItem(
    title: 'Database Design Basics',
    author: 'Michael Lee',
    category: 'Database',
    date: '12 Jul 2026',
  ),
  PopularCourseItem(
    title: 'Backend Authentication',
    author: 'Sarah Kim',
    category: 'Backend',
    date: '10 Jul 2026',
  ),
  PopularCourseItem(
    title: 'PHP Clean Code',
    author: 'Alex Tan',
    category: 'PHP',
    date: '08 Jul 2026',
  ),
  PopularCourseItem(
    title: 'UI/UX Design System',
    author: 'Nadia Putri',
    category: 'UI/UX',
    date: '05 Jul 2026',
  ),
];
