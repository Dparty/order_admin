// ignore_for_file: must_call_super

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Seat.dart';
import '../provider/selection_button_provider.dart';

class SeatWidget extends StatefulWidget {
  SeatWidget({
    Key? key,
    required this.seatIndex,
    required this.seatType,
    this.seatLabel,
    this.searchBarText,
  }) : super(key: ValueKey(seatIndex));

  final int seatIndex;
  final String seatType;
  final String? seatLabel;
  final String? searchBarText;

  @override
  State<SeatWidget> createState() => _SeatWidgetState();
}

class _SeatWidgetState extends State<SeatWidget>
    with AutomaticKeepAliveClientMixin<SeatWidget> {
  @override
  bool get wantKeepAlive => true;

  Seat seat = Seat();

  @override
  void initState() {
    super.initState();
    seat = Seat(
        seatIndex: widget.seatIndex,
        seatType: widget.seatType,
        seatLabel: widget.seatLabel);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionButtonProvider>(
      builder: (context, provider, child) {
        log("SeatWidget Rebuilt");
        log("Seat ${seat.seatLabel} - ${provider.isSeatSelected(seat)}");
        return GestureDetector(
          onTap: () {
            if (provider.selectedSeats.contains(seat)) {
              provider.removeSeat(seat);
            } else {
              provider.addSeat(seat);
            }
          },
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: (widget.searchBarText == widget.seatIndex.toString())
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.transparent,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(
                color: (widget.searchBarText == widget.seatIndex.toString())
                    ? const Color(0xff126DCA)
                    : Colors.transparent,
                width: 2,
              ),
              color: (provider.selectedSeats.contains(seat))
                  ? const Color(0xff126DCA)
                  : const Color(0xffCEEAFF),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.seatLabel.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: (provider.selectedSeats.contains(seat))
                        ? const Color(0xffCEEAFF)
                        : const Color(0xff126DCA),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.seatType,
                  style: TextStyle(
                    fontSize: 12,
                    color: (provider.selectedSeats.contains(seat))
                        ? const Color(0xffCEEAFF)
                        : const Color(0xff126DCA),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
