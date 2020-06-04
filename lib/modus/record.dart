class RecroderModule {
  final num recrodingtime;
  final String fileSize;
  String lastModified;
  String filepath;
  String title;
  bool isPlaying;
  bool isActive;

  RecroderModule({
    this.title,
    this.recrodingtime,
    this.fileSize,
    this.lastModified,
    this.filepath,
    this.isPlaying,
    this.isActive,
  });

  void reset() {
    this.isActive = this.isPlaying = false;
  }

  @override
  String toString() {
    return 'title  $title recrodingtime $recrodingtime';
  }
}
