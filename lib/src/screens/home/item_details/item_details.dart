import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_event.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_diamond_users/src/screens/home/favorite_items/widgets/favorite_button.dart';
import 'package:hot_diamond_users/widgets/custom_button.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class ItemDetailsSheet extends StatefulWidget {
  final ItemModel itemModel;

  const ItemDetailsSheet({super.key, required this.itemModel});

  @override
  ItemDetailsSheetState createState() => ItemDetailsSheetState();
}

class ItemDetailsSheetState extends State<ItemDetailsSheet> {
  int _current = 0;
  int _quantity = 1;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.itemModel.imageUrls.length,
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.itemModel.imageUrls[index],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/placeholder_image.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.itemModel.imageUrls.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.itemModel.name,
                          style: GoogleFonts.poppins(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        FavoriteButton(item: widget.itemModel),
                      ],
                    ),
                    Text(
                      '₹${widget.itemModel.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.itemModel.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(0, 1),
                  color: Colors.grey,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor:_quantity > 1? Colors.red[700] : Colors.grey[300],
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon:  Icon(Icons.remove, color:_quantity > 1? Colors.white : Colors.black),
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _quantity.toString(),
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.red[700],
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(
                      text: 'Add to Cart',
                      onPressed: () {
                        // Add item to cart
                        context.read<CartBloc>().add(
                              AddItemToCart(widget.itemModel, _quantity),
                            );

                        // Show snackbar
                        showCustomSnackbar(
                          context,
                          '${widget.itemModel.name} added to cart!',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
