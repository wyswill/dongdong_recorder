class RecroderModule {
  final String title;
  final String recrodingtime;
  final String fileSize;
  final String lastModified;
  final String filepath;
  bool isPlaying;
  bool isDeleted;
  bool isActive;

  RecroderModule({
    this.title,
    this.recrodingtime,
    this.fileSize,
    this.lastModified,
    this.filepath,
    this.isPlaying,
    this.isDeleted,
    this.isActive,
  });

  @override
  String toString() {
    return 'title  $title recrodingtime $recrodingtime';
  }
}
