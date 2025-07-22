import 'package:digital_academic_portal/shared/domain/entities/CalendarEvent.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

import '../controllers/CalendarEventController.dart';

class CalendarEventPage extends StatefulWidget {
  const CalendarEventPage({super.key});

  @override
  State<CalendarEventPage> createState() => _CalendarEventPageState();
}

class _CalendarEventPageState extends State<CalendarEventPage> {
  final CalendarEventController _controller = Get.find();
  final primaryColor = Get.theme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Get.theme.primaryColor,
              const Color(0xFF1B7660),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Get.theme.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
        onPressed: () => _showAddOrEditDialog(context),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      body: Obx(() {
        return _controller.isCalendarLoading.value
            ? Center(
                child: Lottie.asset(
                  'assets/animations/loading_animation4.json',
                  width: 120,
                  height: 120,
                  fit: BoxFit.scaleDown,
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Modern App Bar with gradient
                  SliverAppBar(
                    expandedHeight: 120.0,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Theme.of(context).primaryColor,
                    leading: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      onPressed: () => Get.back(),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text(
                        'Calendar Events',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              const Color(0xFF1B7660),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Decorative elements
                            Positioned(
                              top: -30,
                              right: -30,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -20,
                              left: -20,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Calendar Section
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _buildCalendarView(),
                      ),
                    ),
                  ),

                  // Events Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.event,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Events',
                            style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'Ubuntu',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),

                  // Events List
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: _buildEventListView(),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),
                ],
              );
      }),
    );
  }

  // Calendar Widget
  Widget _buildCalendarView() {
    return Obx(() {
      return TableCalendar<CalendarEvent>(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: _controller.focusedDay.value,
        selectedDayPredicate: (day) =>
            isSameDay(_controller.selectedDay.value, day),
        onDaySelected: _controller.onDaySelected,
        calendarFormat: _controller.calendarFormat.value,
        onFormatChanged: (format) => _controller.calendarFormat.value = format,
        onPageChanged: (focusedDay) =>
            _controller.focusedDay.value = focusedDay,
        eventLoader: _controller.getEventsForDay,
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: const Color(0xFF1B7660),
            shape: BoxShape.circle,
          ),
        ),
      );
    });
  }

  Widget _buildEventListView() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return SliverFillRemaining(
          child: Center(
          child: Lottie.asset(
            'assets/animations/loading_animation4.json',
            width: 60,
            height: 60,
            fit: BoxFit.scaleDown,
            ),
          ),
        );
      } else {
        final events = _controller.showAllEvents.value
            ? _controller.allEvents.value
            : _controller.getEventsForDay(_controller.selectedDay.value);
        if (events.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                  Icon(
                    Icons.event_busy,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _controller.showAllEvents.value
                        ? 'No events added'
                        : 'No events for this day.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildModernEventCard(event),
              );
            },
            childCount: events.length,
          ),
        );
      }
    });
  }

  Widget _buildModernEventCard(CalendarEvent event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Event icon and color indicator
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    const Color(0xFF1B7660),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.event,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Event details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${event.date.day}-${event.date.month}-${event.date.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Ubuntu',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B7660).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.category,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1B7660),
                            fontFamily: 'Ubuntu',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delete button
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
                onPressed: () => _controller.deleteEvent(
                    _controller.selectedDay.value, event),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOrEditDialog(BuildContext context, {CalendarEvent? event}) {
    if (event != null) {
      _controller.updateEventDetails(event);
    } else {
      _controller.clearFields();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
            mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
            children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        event == null ? Icons.add : Icons.edit,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      event == null ? "Add Event" : "Edit Event",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form fields
              TextField(
                controller: _controller.titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Ubuntu',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),

              TextField(
                controller: _controller.categoryController,
                  decoration: InputDecoration(
                    labelText: "Category",
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Ubuntu',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),

                // Date display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() {
                          return Text(
                            "Date: ${_controller.selectedDay.value.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w500,
                            ),
                );
              }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.of(ctx).pop(),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              const Color(0xFF1B7660),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                if (event == null) {
                  _controller.addEvent();
                } else {
                  final updatedEvent = CalendarEvent(
                    id: event.id,
                                  title:
                                      _controller.titleController.text.trim(),
                                  category: _controller.categoryController.text
                                      .trim(),
                    date: _controller.selectedDay.value,
                  );
                  _controller.editEvent(updatedEvent);
                }
                Navigator.of(ctx).pop();
              },
                            child: Center(
                              child: Text(
                                event == null ? "Add" : "Update",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
