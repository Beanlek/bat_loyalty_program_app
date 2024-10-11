mixin ImageStatusComponents {

      final Map<String, dynamic> receiptData = {
        "Today": [
          {
            "image": 'assets/images_examples/receipt-001.jpg',
            "status": "In Process",
            "created_at": '2024-07-03 09:11:30',
          },          
        ],
        "14 July 2024": [
          {
            "image": 'assets/images_examples/receipt-003.jpg',
            "status": "Completed",
            "created_at": '2024-07-14 10:45:30',
          },
          {
            "image": 'assets/images_examples/receipt-003.jpg',
            "status": "Completed",
            "created_at": '2024-07-14 10:45:30',
          },
          {
            "image": 'assets/images_examples/receipt-004.jpg',
            "status": "Completed",
            "created_at": '2024-07-14 12:30:20',
          },
        ],
        "13 July 2024": [
          {
            "image": 'assets/images_examples/receipt-005.jpg',
            "status": "In Review",
            "created_at": '2024-07-13 09:50:10',
          },
          {
            "image": 'assets/images_examples/receipt-006.jpg',
            "status": "In Process",
            "created_at": '2024-07-13 11:05:40',
          },
        ],
        "12 July 2024": [
          {
            "image": 'assets/images_examples/receipt-007.jpg',
            "status": "Rejected",
            "created_at": '2024-07-12 08:15:30',
          },
          {
            "image": 'assets/images_examples/receipt-008.jpg',
            "status": "Completed",
            "created_at": '2024-07-12 13:45:00',
          },
        ],
      };


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