mixin ImageStatusComponents {
  Map<dynamic, dynamic> receipts = {
    "Today": [
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
    "14 July 2024": [
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-002.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
    "13 July 2024": [
      {
        "image": 'assets/images_examples/receipt-002.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
    "12 Jun 2024": [
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
  };

  final List<Map<dynamic,dynamic>> dateMap = [
    {
      "data": "Any time",
      "filter": false
    },
    {
      "data": "Today",
      "filter": false
    },
    {
      "data": "This week",
      "filter": false
    },
    {
      "data": "This month",
      "filter": false
    },
    {
      "data": "This year",
      "filter": false
    },
  ];
}