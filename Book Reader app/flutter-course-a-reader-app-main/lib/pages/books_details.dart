import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/utils/book_details_arguments.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as BookDetailsArguments?;
    
    if (args == null) {
      return const Scaffold(
        body: Center(child: Text('Book details not available')),
      );
    }

    final Book book = args.itemBook;
    final bool isFromSavedScreen = args.isFromSavedScreen;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (book.imageLinks.isNotEmpty && book.imageLinks['thumbnail'] != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    book.imageLinks['thumbnail']!,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    book.title,
                    style: theme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.authors.join(', '),
                    style: theme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      if (book.publishedDate.isNotEmpty)
                        Text(
                          'Published: ${book.publishedDate}',
                          style: theme.bodySmall,
                        ),
                      if (book.pageCount > 0)
                        Text(
                          'Pages: ${book.pageCount}',
                          style: theme.bodySmall,
                        ),
                      if (book.language.isNotEmpty)
                        Text(
                          'Language: ${book.language}',
                          style: theme.bodySmall,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: !isFromSavedScreen
                        ? ElevatedButton(
                            onPressed: () async {
                              try {
                                await DatabaseHelper.instance.insert(book);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Book Saved")),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error saving book: $e")),
                                );
                              }
                            },
                            child: const Text('Save'),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite),
                            label: const Text('Favorite'),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: theme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: Text(
                      book.description,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
