import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../helper/color.dart';
import '../../models/blog_model.dart';
import '../../services/blog_service.dart';
import '../../widgets/blog_card_widget.dart';

class BlogDetailScreen extends StatefulWidget {
  final Blog blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final BlogService _blogService = BlogService();
  List<Blog> _relatedBlogs = [];

  @override
  void initState() {
    super.initState();
    _loadRelatedBlogs();
  }

  Future<void> _loadRelatedBlogs() async {
    try {
      final blogs = await _blogService.fetchBlogs(
        category: widget.blog.category,
      );
      setState(() {
        _relatedBlogs = blogs
            .where((b) => b.id != widget.blog.id)
            .take(4)
            .toList();
      });
    } catch (e) {
      // Error handled silently, _relatedBlogs remains empty
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context, isDark),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(isDark),
                      const SizedBox(height: 12),
                      _buildDescription(isDark),
                      const SizedBox(height: 16),
                      _buildMetadata(isDark),
                      const SizedBox(height: 24),
                      _buildContent(isDark),
                      const SizedBox(height: 32),
                      if (_relatedBlogs.isNotEmpty) ...[
                        _buildRelatedBlogsSection(isDark),
                        const SizedBox(height: 20),
                      ],
                      const SizedBox(
                        height: 120,
                      ), // Extra space for sticky button
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildStickyChatButton(context),
        ],
      ),
      bottomSheet: _buildShareButton(context, isDark),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.white),
          ),
          onPressed: _shareArticle,
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bookmark_border, color: Colors.white),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Bookmark feature coming soon!")),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              widget.blog.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Return placeholder if specific asset fails
                return Container(
                  color: isDark ? AppColors.darkSection : Colors.grey.shade200,
                  child: Icon(
                    Icons.article,
                    size: 80,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                );
              },
            ),
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.blog.getCategoryColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.blog.getCategoryColor().withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.blog.getCategoryIcon(),
                size: 16,
                color: widget.blog.getCategoryColor(),
              ),
              const SizedBox(width: 6),
              Text(
                widget.blog.category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.blog.getCategoryColor(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Title
        Text(
          widget.blog.title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadata(bool isDark) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.goldAccent.withOpacity(0.2),
          child: Icon(Icons.person, color: AppColors.goldAccent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.blog.author,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.blog.readTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(widget.blog.publishDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(bool isDark) {
    return Text(
      widget.blog.excerpt,
      style: TextStyle(
        fontSize: 16,
        color: isDark ? Colors.white70 : Colors.black54,
        height: 1.5,
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    final lines = widget.blog.content.split('\n');

    // Simple parser for 911 blog structure
    if (widget.blog.id == '911') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableOfContents(isDark),
          const SizedBox(height: 24),
          ...lines.map((line) {
            if (line.startsWith('### ')) {
              return Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 8),
                child: Text(
                  line.replaceFirst('### ', ''),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              );
            } else if (line.startsWith('## ')) {
              // Skip "Table of Contents" title as we build it custom
              if (line.contains('Table of Contents'))
                return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 28, bottom: 12),
                child: Text(
                  line.replaceFirst('## ', ''),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              );
            } else if (line.startsWith('**') && line.endsWith('**')) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  line.replaceAll('**', ''),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              );
            } else if (line.trim().isEmpty || line.startsWith('# ')) {
              return const SizedBox.shrink();
            } else if (line.startsWith('- ') || line.startsWith('    - ')) {
              // Skip TOC items manually handled
              if (line.contains('Why 911 Angel Numbers') ||
                  line.contains('What Does 911'))
                return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• ",
                      style: TextStyle(
                        color: AppColors.goldAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        line.replaceFirst(RegExp(r'^\s*-\s*'), ''),
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark
                              ? Colors.white.withOpacity(0.9)
                              : Colors.black87,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.8,
                  color: isDark
                      ? Colors.white.withOpacity(0.9)
                      : Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            );
          }).toList(),
        ],
      );
    }

    // Default content rendering
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Text(
        widget.blog.content,
        style: TextStyle(
          fontSize: 15,
          height: 1.8,
          color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildTableOfContents(bool isDark) {
    final tocItems = [
      "Why 911 Angel Numbers Are Important?",
      "What Does 911 Angel Number Mean For Love?",
      "What Does 911 Angel Number Mean For Twin Flame Journey?",
      "What Does 911 Angel Number Mean For Career?",
      "What Does 911 Angel Number Mean For Money?",
      "What Does 911 Angel Number Mean For Relationships?",
      "What Does 911 Angel Number Mean For Work?",
      "What Does 911 Angel Number Mean For Manifestation?",
      "What Should I Do If I Keep Seeing 911 Angel Number?",
      "Conclusion",
      "FAQs",
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Table of Contents",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Icon(Icons.list, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          ...tocItems.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 6, color: Colors.grey.shade400),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyChatButton(BuildContext context) {
    return Positioned(
      bottom: 100, // Above the share button bottom sheet
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to chat or show info
            },
            icon: const Icon(Icons.chat_bubble, color: Colors.black),
            label: const Text(
              "Free chat with Astrologer",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedBlogsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.goldAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Related Articles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _relatedBlogs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final relatedBlog = _relatedBlogs[index];
              return BlogCardWidget(
                blog: relatedBlog,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlogDetailScreen(blog: relatedBlog),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _shareArticle,
              icon: const Icon(Icons.share),
              label: const Text(
                "Share Article",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _copyLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.darkSection
                  : Colors.grey.shade200,
              foregroundColor: isDark ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Icon(Icons.link),
          ),
        ],
      ),
    );
  }

  void _shareArticle() {
    Share.share(
      '${widget.blog.title}\n\nRead this amazing article on Devine Astrology App!\n\n${widget.blog.excerpt}',
      subject: widget.blog.title,
    );
  }

  void _copyLink() {
    Clipboard.setData(
      ClipboardData(text: 'https://devineapp.com/blog/${widget.blog.id}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Link copied to clipboard!"),
        backgroundColor: AppColors.goldAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
