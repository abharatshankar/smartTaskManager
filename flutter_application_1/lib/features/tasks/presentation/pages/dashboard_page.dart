import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/socket_service.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../presentation/bloc/task_cubit.dart';
import '../../presentation/bloc/task_state.dart';
import '../widgets/task_form_sheet.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _socketService = SocketService();

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadDashboard();
    _socketService.connect(onTaskUpdate: (message) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      context.read<TaskCubit>().loadDashboard();
    });
  }

  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }

  void _showTaskForm({Map<String, dynamic>? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => TaskFormSheet(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = context
        .select((AuthCubit cubit) => cubit.state.user?.username ?? 'User');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => _showTaskForm(),
              icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskForm(),
        backgroundColor: const Color(0xFF4F5FE8),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          final analytics = state.analytics;
          return RefreshIndicator(
            onRefresh: () => context.read<TaskCubit>().loadDashboard(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _welcomeCard(username),
                const SizedBox(height: 16),
                _statsGrid(analytics.totalTasks, analytics.completedTasks,
                    analytics.pendingTasks, analytics.completionPercentage),
                const SizedBox(height: 16),
                _completionCard(analytics.completedTasks,
                    analytics.pendingTasks, analytics.completionPercentage),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Your Tasks',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text('${state.tasks.length} items',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                if (state.loading)
                  const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()))
                else if (state.tasks.isEmpty)
                  _emptyCard()
                else
                  ...state.tasks.map((task) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Text(task.title,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800))),
                                    const SizedBox(width: 8),
                                    _pill(
                                        task.priority,
                                        task.priority == 'High'
                                            ? Colors.red
                                            : task.priority == 'Low'
                                                ? Colors.green
                                                : Colors.orange),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(task.description,
                                    style:
                                        TextStyle(color: Colors.grey.shade700)),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _pill(
                                        task.status,
                                        task.status == 'Completed'
                                            ? Colors.green
                                            : task.status == 'In Progress'
                                                ? Colors.blue
                                                : Colors.orange),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () => _showTaskForm(task: {
                                        'id': task.id,
                                        'title': task.title,
                                        'description': task.description,
                                        'priority': task.priority,
                                        'status': task.status
                                      }),
                                      icon: const Icon(Icons.edit,
                                          color: Color(0xFF4F5FE8)),
                                    ),
                                    IconButton(
                                      onPressed: () => context
                                          .read<TaskCubit>()
                                          .deleteTask(task.id),
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                const SizedBox(height: 90),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _welcomeCard(String username) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF4F5FE8), Color(0xFF7C3AED)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white24,
              child: Icon(Icons.checklist, color: Colors.white, size: 30)),
          const SizedBox(width: 14),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Welcome back, $username',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18)),
              const SizedBox(height: 4),
              const Text('Manage tasks from your mobile app',
                  style: TextStyle(color: Colors.white70)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _statsGrid(int total, int completed, int pending, double pct) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.45,
      children: [
        _statTile('Total', total.toString(), Icons.assignment,
            const Color(0xFFE7EFFF)),
        _statTile('Completed', completed.toString(), Icons.check_circle,
            const Color(0xFFE7F8EF)),
        _statTile('Pending', pending.toString(), Icons.access_time,
            const Color(0xFFFFF4DD)),
        _statTile('Done %', '${pct.toStringAsFixed(0)}%', Icons.bar_chart,
            const Color(0xFFF0EAFE)),
      ],
    );
  }

  Widget _statTile(String title, String value, IconData icon, Color bg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, size: 22)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          ]),
        ],
      ),
    );
  }

  Widget _completionCard(int completed, int pending, double pct) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: pct / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.orange.shade100,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF22C55E)),
                  ),
                  Text('${pct.toStringAsFixed(0)}%',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Task Completion Overview',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Text('Completed: $completed'),
                    Text('Pending: $pending'),
                    Text('Total: ${completed + pending}'),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
            child: Text(
                'No tasks yet. Tap "Add Task" to create your first task.')),
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}
