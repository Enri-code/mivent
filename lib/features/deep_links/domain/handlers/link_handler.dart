abstract class IDeepLinkHandler<T> {
  String get pathId;

  void createLink(T data);
  handleLink(Uri link);
}
