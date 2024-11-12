String formatTimeDifference(DateTime notificationTime) {
    final difference = DateTime.now().difference(notificationTime);

    if (difference.inDays >= 7) {
      return '${difference.inDays ~/ 7}w';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes == 0) {
      return 'just Now';
    } else {
      return '${difference.inMinutes}m';
    }
  }