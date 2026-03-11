import 'package:flutter/material.dart';
import 'package:latihan_kuis_a/models/movie_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  int jumlahPesan = 0;
  int totalHarga = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(widget.movie.movieUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.movie.isBookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: widget.movie.isBookmarked ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                widget.movie.isBookmarked = !widget.movie.isBookmarked;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Image
                  Image.network(
                    widget.movie.imgUrl,
                    height: 400,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 400,
                      color: Colors.grey,
                      child: const Center(child: Icon(Icons.error, size: 50)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '${widget.movie.title} (${widget.movie.year})',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.movie.rating}/10',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Directed by ${widget.movie.director}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Price
                        Text(
                          'IDR ${widget.movie.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Synopsis
                        Text(
                          widget.movie.synopsis,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 16),

                        // Genre Box Status
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.movie.genre.map((genre) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                genre,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Casts
                        Text(
                          'Casts: ${widget.movie.casts.join(', ')}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Review Section
                        const Divider(thickness: 1),
                        const SizedBox(height: 16),
                        const Text(
                          "Review Terakhir:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            border: Border.all(color: Colors.blue.shade200),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '"${widget.movie.lastReview}"',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Input Review
                        TextField(
                          controller: _reviewController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            labelText: "Tulis Review Baru",
                            labelStyle: const TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              String reviewBaru = _reviewController.text;

                              if (reviewBaru.isNotEmpty) {
                                setState(() {
                                  widget.movie.lastReview = reviewBaru;
                                });
                                _reviewController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.blue,
                                    content: Text("Review Terkirim"),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            child: const Text("Kirim Review"),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Wikipedia Button
                        ElevatedButton(
                          onPressed: _launchURL,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Go to Wikipedia'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Checkout Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (jumlahPesan > 0) {
                                jumlahPesan--;
                                totalHarga = jumlahPesan * widget.movie.price;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove, size: 20),
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$jumlahPesan',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              jumlahPesan++;
                              totalHarga = jumlahPesan * widget.movie.price;
                            });
                          },
                          icon: const Icon(Icons.add, size: 20),
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Checkout button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: jumlahPesan > 0
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Berhasil Checkout $jumlahPesan Tiket!',
                                  ),
                                ),
                              );
                              // Reset setelah checkout
                              setState(() {
                                jumlahPesan = 0;
                                totalHarga = 0;
                              });
                              Navigator.pop(context);
                            }
                          : null,
                      child: Text(
                        jumlahPesan > 0
                            ? 'Checkout - Rp $totalHarga'
                            : 'Checkout',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
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
}
