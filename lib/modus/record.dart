class RecroderModule {
  final String title;
  final String recrodingtime;
  final String fileSize;
  final String lastModified;
  final String filepath;
  final String attr;
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
    this.attr,
  });

  void reset() {
    this.isActive = this.isPlaying = false;
  }

  @override
  String toString() {
    return 'title  $title recrodingtime $recrodingtime';
  }
}
