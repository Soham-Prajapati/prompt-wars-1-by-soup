import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming QueueInfo is available via a similar provider. We'll use a mocked provider here for UI.
import 'package:stadium_iq/features/orders/domain/entities/order.dart';

final queuesProvider = FutureProvider<List<QueueInfo>>((ref) async {
  // Mock fetching queue data
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    const QueueInfo(
        stallId: 'S1', stallName: 'Burger Stand West', waitMins: 3.5, queueLength: 8, forecast15min: 5.0, source: 'pos'),
    const QueueInfo(
        stallId: 'S2', stallName: 'Beer Express 1', waitMins: 12.0, queueLength: 25, forecast15min: 15.0, source: 'sensor'),
    const QueueInfo(
        stallId: 'S3', stallName: 'Merch Shop North', waitMins: 1.0, queueLength: 2, forecast15min: 2.0, source: 'cctv'),
  ]..sort((a, b) => a.waitMins.compareTo(b.waitMins));
});

class QueueListScreen extends ConsumerWidget {
  const QueueListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queuesAsync = ref.watch(queuesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Wait Times'),
      ),
      body: queuesAsync.when(
        data: (queues) {
          return ListView.builder(
            itemCount: queues.length,
            itemBuilder: (context, index) {
              final queue = queues[index];
              final isFast = queue.waitMins < 5;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    Icons.fastfood,
                    color: isFast ? Colors.green : Colors.orange,
                  ),
                  title: Text(queue.stallName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Wait: ${queue.waitMins} min | Queue: ${queue.queueLength} people'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigate to order screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFast ? Colors.green : null,
                    ),
                    child: const Text('Order'),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error loading queues: $error')),
      ),
    );
  }
}
