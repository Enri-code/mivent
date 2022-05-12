import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/encryptor/data/models/key.dart';
import 'package:mivent/features/encryptor/domain/encryptor.dart';
import 'package:mivent/features/store/data/fire_storage.dart';
import 'package:mivent/features/tickets/data/models/owned_ticket.dart';
import 'package:mivent/features/tickets/data/models/ticket.dart';
import 'package:mivent/features/tickets/domain/entities/owned_ticket.dart';

class FireOwnedTicketStorage
    extends FireStorage<OwnedTicket, Map<String, dynamic>> {
  FireOwnedTicketStorage(IEncryptor encryptor, {bool autoUpdate = true})
      : super(
          'ticket_orders',
          autoUpdate: autoUpdate,
          querySource: () async {
            await FireSetup.waitForInit;
            return FirebaseFirestore.instance
                .collectionGroup(FireConstants.ticketOrdersCollName);
          },
          modifier: (data) async {
            var ticketDocs = await FirebaseFirestore.instance
                .collectionGroup(FireConstants.ticketsCollName)
                .withConverter<Map<String, Object?>>(
                  fromFirestore: (doc, _) {
                    var data = doc.data()!;
                    data['id'] = doc.id;
                    data = FireStoreHelper.setPreviewImageGetter(
                        data, FireConstants.ticketsPath);
                    return data;
                  },
                  toFirestore: (data, _) => data,
                )
                .where(
                  FieldPath.documentId,
                  whereIn: data.map((e) => e['ticket_id']).toList(),
                )
                .get();

            return data.map((d) {
              d['ticket'] =
                  ticketDocs.docs.firstWhere((t) => d['ticket_id'] == t['id']);
              return d;
            });
          },
          fromConverter: (data) async {
            var ticket = TicketModel.fromMap(data['ticket']);
            return OwnedTicketModel.withTicket(
              data['id'],
              ticket,
              orderId: data['order_id'],
              qrData: encryptor.encrypt(
                json.encode({
                  'owned_ticket_id': data['id'],
                  'event_id': ticket.event.id,
                  'ticket_info': TicketModel.infoToMap(ticket)..remove('id'),
                }),
                EncryptKeyModel.fromMap(data),
              ),
            );
          },
        );
}
