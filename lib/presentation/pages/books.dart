import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/theme.dart';

class BookItem {
  final String id;
  final String title;
  final String author;
  final String category;
  final String status;
  final double rating;

  const BookItem({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.status,
    required this.rating,
  });
}

const List<BookItem> sampleBooks = [
  BookItem(
    id: '1',
    title: 'Clean Code',
    author: 'Robert C. Martin',
    category: 'Engineering',
    status: 'Completed',
    rating: 4.8,
  ),
  BookItem(
    id: '2',
    title: 'The Pragmatic Programmer',
    author: 'David Thomas & Andrew Hunt',
    category: 'Engineering',
    status: 'Reading',
    rating: 4.9,
  ),
  BookItem(
    id: '3',
    title: 'Design of Everyday Things',
    author: 'Don Norman',
    category: 'Design',
    status: 'Reading',
    rating: 4.7,
  ),
  BookItem(
    id: '4',
    title: 'Refactoring',
    author: 'Martin Fowler',
    category: 'Engineering',
    status: 'Completed',
    rating: 4.8,
  ),
  BookItem(
    id: '5',
    title: 'Sprint: How to Solve Big Problems',
    author: 'Jake Knapp',
    category: 'Product',
    status: 'Wishlist',
    rating: 4.6,
  ),
  BookItem(
    id: '6',
    title: 'Atomic Habits',
    author: 'James Clear',
    category: 'Productivity',
    status: 'Completed',
    rating: 4.9,
  ),
];

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  String _selectedCategory = 'All';
  final Set<String> _favorites = {'1', '2'};

  final List<String> _categories = [
    'All',
    'Engineering',
    'Design',
    'Product',
    'Productivity',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredBooks = _selectedCategory == 'All'
        ? sampleBooks
        : sampleBooks.where((b) => b.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            children: [
              // Page header description
              Semantics(
                header: true,
                child: Text(
                  'Your Reading Library',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? BrandColors.white : BrandColors.darkGrey,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Explore books, track reading milestones, and manage your collection.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: BrandColors.neutral,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Category filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(category),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor:
                            BrandColors.primary.withValues(alpha: 0.18),
                        checkmarkColor: BrandColors.primary,
                        labelStyle: GoogleFonts.ibmPlexSans(
                          color: isSelected
                              ? BrandColors.primary
                              : (isDark ? BrandColors.white : BrandColors.darkGrey),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Responsive Books List or Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 600 ? 2 : 1;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      mainAxisExtent: 140,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      final isFav = _favorites.contains(book.id);

                      return _BookCard(
                        book: book,
                        isFavorite: isFav,
                        onToggleFavorite: () {
                          setState(() {
                            if (isFav) {
                              _favorites.remove(book.id);
                            } else {
                              _favorites.add(book.id);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final BookItem book;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _BookCard({
    required this.book,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return BrandColors.success;
      case 'Reading':
        return BrandColors.info;
      default:
        return BrandColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(book.status);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      color: isDark ? BrandColors.darkGrey : BrandColors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover icon badge
            Container(
              width: 52,
              height: 72,
              decoration: BoxDecoration(
                color: BrandColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: BrandColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? BrandColors.white : BrandColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: BrandColors.neutral,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          book.status,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star_rounded, size: 16, color: BrandColors.warning),
                      const SizedBox(width: 2),
                      Text(
                        book.rating.toString(),
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? BrandColors.white : BrandColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Favorite action button
            Semantics(
              button: true,
              label: isFavorite
                  ? 'Remove ${book.title} from favorites'
                  : 'Add ${book.title} to favorites',
              child: IconButton(
                onPressed: onToggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? BrandColors.primary : BrandColors.neutral,
                  size: 22,
                ),
                tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
