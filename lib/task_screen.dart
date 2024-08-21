import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:namekart/state_management.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TaskScreen extends StatefulWidget {
  final Map<String, dynamic>? task;

  TaskScreen({this.task});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _deadline;
  bool _isCompleted = false;

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListeningTitle = false;
  bool _isListeningDescription = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!['title'];
      _descriptionController.text = widget.task!['description'];
      _deadline = DateTime.parse(widget.task!['deadline']);
      _isCompleted = widget.task!['isCompleted'] == 1;
    } else {
      _deadline = DateTime.now(); // Set default deadline to today
    }
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      // Do nothing; permissions are granted
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is not granted')),
      );
    }
  }

  void _startListening(String field) async {
    if (field == 'title' && !_isListeningTitle) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListeningTitle = true;
        });
        _speech.listen(onResult: (result) {
          setState(() {
            _titleController.text = result.recognizedWords;
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition is not available')),
        );
      }
    } else if (field == 'description' && !_isListeningDescription) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListeningDescription = true;
        });
        _speech.listen(onResult: (result) {
          setState(() {
            _descriptionController.text = result.recognizedWords;
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition is not available')),
        );
      }
    }
  }

  void _stopListening(String field) {
    if (field == 'title' && _isListeningTitle) {
      _speech.stop();
      setState(() {
        _isListeningTitle = false;
      });
    } else if (field == 'description' && _isListeningDescription) {
      _speech.stop();
      setState(() {
        _isListeningDescription = false;
      });
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      if (_deadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a deadline')),
        );
        return;
      }

      final task = {
        'id': widget.task?['id'],
        'title': _titleController.text,
        'description': _descriptionController.text,
        'deadline': _deadline!.toIso8601String(),
        'isCompleted': _isCompleted ? 1 : 0,
      };

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (widget.task == null) {
        taskProvider.addTask(task);
      } else {
        taskProvider.updateTask(task);
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
        backgroundColor: const Color(0xffF4C2C2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:
                            Icon(_isListeningTitle ? Icons.mic_off : Icons.mic),
                        onPressed: () async {
                          var status = await Permission.microphone.status;
                          if (status.isGranted) {
                            if (_isListeningTitle) {
                              _stopListening('title');
                            } else {
                              await _requestPermissions();
                              _startListening('title');
                            }
                          } else {
                            await _requestPermissions();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(_isListeningDescription
                            ? Icons.mic_off
                            : Icons.mic),
                        onPressed: () async {
                          var status = await Permission.microphone.status;
                          if (status.isGranted) {
                            if (_isListeningDescription) {
                              _stopListening('description');
                            } else {
                              await _requestPermissions();
                              _startListening('description');
                            }
                          } else {
                            await _requestPermissions();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(
                  _deadline == null
                      ? 'Select Deadline'
                      : DateFormat('yyyy-MM-dd HH:mm').format(_deadline!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _deadline ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay.fromDateTime(_deadline ?? DateTime.now()),
                    );

                    if (time != null) {
                      final combinedDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );

                      setState(() {
                        _deadline = combinedDateTime;
                      });

                      print("Selected date and time: $combinedDateTime");
                    }
                  }
                },
              ),
              const SizedBox(height: 16.0),
              SwitchListTile(
                title: const Text('Completed'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text('Save Task'),
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
