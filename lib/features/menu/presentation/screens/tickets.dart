import 'package:flutter/material.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      child: Column(
        children: [],
      ),
    );
  }
}

class _TicketsCheckout extends StatelessWidget {
  const _TicketsCheckout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //show event and tickets of it
    //button to checkout
    //scan multiple tickets with 1 qr code
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [],
            ),
          ),
        ),
        Container(
          height: 200,
          /*  decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26)],
          ), */
        ),
      ],
    );
  }
}
