import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_event.dart';
import 'package:hot_diamond_users/src/enum/discount_type.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/model/variation/variation_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_diamond_users/src/screens/home/favorite_items/widgets/favorite_button.dart';
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
  VariationModel? _selectedVariation;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    if (widget.itemModel.variations.isNotEmpty) {
      _selectedVariation = widget.itemModel.variations.first;
    }
  }

  double get currentPrice {
    double basePrice = _selectedVariation?.price ?? widget.itemModel.price;
    return widget.itemModel.hasValidOffer
        ? widget.itemModel.calculateDiscountedPrice(basePrice)
        : basePrice;
  }

  Widget _buildVariationSelector() {
    if (widget.itemModel.variations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Select Variation',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.itemModel.variations.map((variation) {
            final isSelected = _selectedVariation?.id == variation.id;
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedVariation = variation;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red[700] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.red[700]! : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  variation.displayName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

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
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
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
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
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
                      children: widget.itemModel.imageUrls
                          .asMap()
                          .entries
                          .map((entry) {
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
                  _buildOfferBadge(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.itemModel.name,
                                  style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                FavoriteButton(item: widget.itemModel),
                              ],
                            ),
                            _buildPriceSection(),
                            const SizedBox(height: 8),
                            Text(
                              widget.itemModel.description,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            _buildVariationSelector(),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (widget.itemModel.hasValidOffer) _buildOfferDetails(),
                    const SizedBox(
                      height: 80,
                    )
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 77, 67, 67).withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  _buildQuantityControls(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<CartBloc>().add(
                              AddItemToCart(widget.itemModel, _quantity,
                                  selectedVariation: _selectedVariation),
                            );
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
        )
      ],
    );
  }

  Widget _buildOfferDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer_outlined, color: Colors.red[700]),
              const SizedBox(width: 8),
              Text(
                'Special Offer',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.itemModel.offer!.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.red[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Valid till ${widget.itemModel.offer!.endDate.toString().split(' ')[0]}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.red[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    double originalPrice = _selectedVariation?.price ?? widget.itemModel.price;
    return Row(
      children: [
        Text(
          '₹${currentPrice.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        if (widget.itemModel.hasValidOffer) ...[
          const SizedBox(width: 8),
          Text(
            '₹${originalPrice.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOfferBadge() {
    if (!widget.itemModel.hasValidOffer) return const SizedBox.shrink();

    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.itemModel.offer!.discountType == DiscountType.percentage
              ? '${widget.itemModel.offer!.discountValue.toStringAsFixed(0)}% OFF'
              : '₹${widget.itemModel.offer!.discountValue} OFF',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 32),
            icon: Icon(
              Icons.remove,
              color: _quantity > 1 ? Colors.red[700] : Colors.grey,
              size: 20,
            ),
            onPressed: _quantity > 1
                ? () {
                    setState(() {
                      _quantity--;
                    });
                  }
                : null,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 36),
            child: Text(
              _quantity.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 32),
            icon: Icon(
              Icons.add,
              color: Colors.red[700],
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _quantity++;
              });
            },
          ),
        ],
      ),
    );
  }
}
