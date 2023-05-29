import 'package:flutter/material.dart';

class PaginationWidget extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final int displayPages;
  final Function(int) onPageChanged;

  PaginationWidget({
    required this.currentPage,
    required this.totalPages,
    this.displayPages = 5,
    required this.onPageChanged,
  });

  @override
  _PaginationWidgetState createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<PaginationWidget> {
  int _startIndex = 1;

  void _updateStartIndex() {
    if (widget.totalPages > widget.displayPages &&
        widget.currentPage >= widget.displayPages) {
      _startIndex = widget.currentPage - (widget.displayPages - 1);
    } else {
      _startIndex = 1;
    }
  }

  Widget _buildPageButton(int pageNumber) {
    final bool isCurrentPage = pageNumber == widget.currentPage;

    return Container(
      width: 35,
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: AspectRatio(
        aspectRatio: 1.0, // Set aspect ratio to 1:1
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor:
                  isCurrentPage ? Theme.of(context).primaryColor : null),
          onPressed: () {
            widget.onPageChanged(pageNumber);
          },
          child: Text(
            pageNumber.toString(),
            style: TextStyle(
              color: isCurrentPage ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateStartIndex();

    List<Widget> pageButtons = [];

    if (widget.currentPage != 1) {
      pageButtons.add(
        TextButton(
          onPressed: () {
            widget.onPageChanged(widget.currentPage - 1);
          },
          child: Text('Prev'),
        ),
      );
    }

    if (widget.totalPages <= widget.displayPages) {
      for (int i = 1; i <= widget.totalPages; i++) {
        pageButtons.add(_buildPageButton(i));
      }
    } else {
      if (_startIndex > 2) {
        pageButtons.add(_buildPageButton(1));
        pageButtons.add(Text(' ... '));
      }

      for (int i = _startIndex; i < _startIndex + widget.displayPages; i++) {
        if (i <= widget.totalPages) {
          pageButtons.add(_buildPageButton(i));
        }
      }

      if (_startIndex + widget.displayPages < widget.totalPages) {
        pageButtons.add(Text(' ... '));
        pageButtons.add(_buildPageButton(widget.totalPages));
      }
    }

    if (widget.currentPage != widget.totalPages) {
      if (widget.currentPage == widget.totalPages - 1) {
        pageButtons.add(_buildPageButton(widget.totalPages));
      }

      pageButtons.add(
        TextButton(
          onPressed: () {
            widget.onPageChanged(widget.currentPage + 1);
          },
          child: Text('Next'),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pageButtons,
    );
  }
}
