import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
// If you are using local files, add the permission_handler
// dependency to pubspec.yaml and uncomment the line below.
// import 'package:permission_handler/permission_handler.dart';

//set this value to view document via Widget
var enableWidget = true;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Viewer(),
    );
  }
}

class Viewer extends StatefulWidget {
  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  String _version = 'Unknown';
  String _document =
      "https://hfw-oss-public.oss-cn-hangzhou.aliyuncs.com/PDF/assetallocation/2023_05_05/16832638532437736pkld5zs/EESD_9600_Application.pdf";

  final String _annotationStr = 'PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiID8+PHhmZGYgeG1sbnM9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGZkZi8iIHhtbDpzcGFjZT0icHJlc2VydmUiPjxwZGYtaW5mbyB4bWxucz0iaHR0cDovL3d3dy5wZGZ0cm9uLmNvbS9wZGZpbmZvIiB2ZXJzaW9uPSIyIiBpbXBvcnQtdmVyc2lvbj0iNCI+PGZmaWVsZCB0eXBlPSJUeCIgbmFtZT0iUGFyZW50QUluaXRpYWw/cm9sZT1mYW1pbHkmYW1wO3BhZ2U9LTEiPjxmb250IG5hbWU9IkhlbHZldGljYSIgc2l6ZT0iMTIiIC8+PC9mZmllbGQ+PGZmaWVsZCB0eXBlPSJUeCIgbmFtZT0iUGFyZW50QlNpZ25EYXRlP3JvbGU9ZmFtaWx5JmFtcDtwYWdlPS0xJmFtcDtkZWZhdWx0dmFsdWU9Y3VycmVudGRhdGUiPjxmb250IG5hbWU9IkhlbHZldGljYSIgc2l6ZT0iMTIiIC8+PC9mZmllbGQ+PGZmaWVsZCB0eXBlPSJTaWciIG5hbWU9IlBhcmVudEFTaWduP3JvbGU9ZmFtaWx5JmFtcDtwYWdlPS0xIiBmbGFncz0iUmVxdWlyZWQiIC8+PGZmaWVsZCB0eXBlPSJTaWciIG5hbWU9IlBhcmVudEJTaWduP3JvbGU9ZmFtaWx5JmFtcDtwYWdlPS0xIiAvPjxmZmllbGQgdHlwZT0iVHgiIG5hbWU9IlBhcmVudEFTaWduRGF0ZT9yb2xlPWZhbWlseSZhbXA7cGFnZT0tMSZhbXA7ZGVmYXVsdFZhbHVlPUN1cnJlbnREYXRlIiBmbGFncz0iUmVxdWlyZWQiPjxmb250IG5hbWU9IkhlbHZldGljYSIgc2l6ZT0iMTIiIC8+PC9mZmllbGQ+PGZmaWVsZCB0eXBlPSJTaWciIG5hbWU9IlNpZ25hdHVyZUZvcm1GaWVsZCA1P3BhZ2U9LTEiIC8+PGZmaWVsZCB0eXBlPSJTaWciIG5hbWU9IlNpZ25hdHVyZUZvcm1GaWVsZCA2P3BhZ2U9LTEiIC8+PGZmaWVsZCB0eXBlPSJUeCIgbmFtZT0iVGV4dEZvcm1GaWVsZCA3P3BhZ2UtMSI+PGZvbnQgbmFtZT0iSGVsdmV0aWNhIiBzaXplPSIxMiIgLz48L2ZmaWVsZD48ZmZpZWxkIHR5cGU9IlR4IiBuYW1lPSJUZXh0Rm9ybUZpZWxkIDg/cGFnZT0tMSI+PGZvbnQgbmFtZT0iSGVsdmV0aWNhIiBzaXplPSIxMiIgLz48L2ZmaWVsZD48ZmZpZWxkIHR5cGU9IlR4IiBuYW1lPSJUZXh0Rm9ybUZpZWxkIDk/cGFnZT0tMSI+PGZvbnQgbmFtZT0iSGVsdmV0aWNhIiBzaXplPSIxMiIgLz48L2ZmaWVsZD48ZmZpZWxkIHR5cGU9IlR4IiBuYW1lPSJUZXh0Rm9ybUZpZWxkIDEwIj48Zm9udCBuYW1lPSJIZWx2ZXRpY2EiIHNpemU9IjEyIiAvPjwvZmZpZWxkPjxmZmllbGQgdHlwZT0iVHgiIG5hbWU9IlRleHRGb3JtRmllbGQgNSI+PGZvbnQgbmFtZT0iSGVsdmV0aWNhIiBzaXplPSIxMiIgLz48L2ZmaWVsZD48ZmZpZWxkIHR5cGU9IlNpZyIgbmFtZT0iU2lnbmF0dXJlRm9ybUZpZWxkIDE2P3BhZ2U9LTEiIC8+PGZmaWVsZCB0eXBlPSJTaWciIG5hbWU9IlNpZ25hdHVyZUZvcm1GaWVsZCAxP3BhZ2U9LTEmYW1wO3JvbGU9ZmFtaWx5IiAvPjxmZmllbGQgdHlwZT0iU2lnIiBuYW1lPSJTaWduYXR1cmVGb3JtRmllbGQgMj9wYWdlPS0xJmFtcDtyb2xlPWZhbWlseSIgLz48ZmZpZWxkIHR5cGU9IlR4IiBuYW1lPSJUZXh0Rm9ybUZpZWxkIDM/cGFnZT0tMSZhbXA7cm9sZT1mYW1pbHkiPjxmb250IG5hbWU9IkhlbHZldGljYSIgc2l6ZT0iMTIiIC8+PC9mZmllbGQ+PGZmaWVsZCB0eXBlPSJUeCIgbmFtZT0iVGV4dEZvcm1GaWVsZCA0P3BhZ2U9LTEmYW1wO3JvbGU9ZmFtaWx5Ij48Zm9udCBuYW1lPSJIZWx2ZXRpY2EiIHNpemU9IjEyIiAvPjwvZmZpZWxkPjxmZmllbGQgdHlwZT0iVHgiIG5hbWU9IlRleHRGb3JtRmllbGQgMT9wYWdlPS0xJmFtcDtyb2xlPWZhbWlseSI+PGZvbnQgbmFtZT0iSGVsdmV0aWNhIiBzaXplPSIxMiIgLz48L2ZmaWVsZD48ZmZpZWxkIHR5cGU9IlNpZyIgbmFtZT0iU2lnbmF0dXJlRm9ybUZpZWxkIDYwP3BhZ2U9LTEmYW1wO3JvbGU9YWdlbmN5IiAvPjx3aWRnZXQgYXBwZWFyYW5jZT0iX0RFRkFVTFQiIGZpZWxkPSJTaWduYXR1cmVGb3JtRmllbGQgMT9wYWdlPS0xJmFtcDtyb2xlPWZhbWlseSIgbmFtZT0iOTdkMzYzNWQtMzE1Ny04MjYxLTQ0YTMtNjU4OTNlYzgyYjM5IiBtb2RpZmllZC1kYXRlPSJEOjIwMjQwNTA2MTE1OTUwKzA4JzAwJyIgcGFnZT0iMiI+PHJlY3QgeDE9IjQ4LjI0IiB4Mj0iMTg4LjI0IiB5MT0iMjI2LjkiIHkyPSIyNDQuNTUiIC8+PGJvcmRlciBzdHlsZT0ibnVsbCIgLz48YXBwZWFyYW5jZXM+PGFhcHBlYXJhbmNlIG5hbWU9Il9ERUZBVUxUIj48Tm9ybWFsPmRhdGE6aW1hZ2UvcG5nO2Jhc2U2NCxpVkJPUncwS0dnb0FBQUFOU1VoRVVnQUFBQUVBQUFBQkNBWUFBQUFmRmNTSkFBQUFBWE5TUjBJQXJzNGM2UUFBQUFSblFVMUJBQUN4and2OFlRVUFBQUFKY0VoWmN3QUFEc01BQUE3REFjZHZxR1FBQUFBWWRFVllkRk52Wm5SM1lYSmxBSEJoYVc1MExtNWxkQ0EwTGpFdU1XTXFuRXNBQUFBTlNVUkJWQmhYWS9qLy96OERBQWo4QXY2SVh3YmdBQUFBQUVsRlRrU3VRbUNDPC9Ob3JtYWw+PC9hYXBwZWFyYW5jZT48L2FwcGVhcmFuY2VzPjwvd2lkZ2V0Pjx3aWRnZXQgYXBwZWFyYW5jZT0iX0RFRkFVTFQiIGZpZWxkPSJTaWduYXR1cmVGb3JtRmllbGQgMj9wYWdlPS0xJmFtcDtyb2xlPWZhbWlseSIgbmFtZT0iYzkzNTdiNDYtOGEyNi0yZDI1LTJiYmItOTZkMjRkZWY2ZWE1IiBtb2RpZmllZC1kYXRlPSJEOjIwMjQwNTA2MTE1OTUwKzA4JzAwJyIgcGFnZT0iMiI+PHJlY3QgeDE9IjQ3LjM1IiB4Mj0iMTg3LjM1IiB5MT0iMjA3LjgxIiB5Mj0iMjI1LjgxIiAvPjxib3JkZXIgc3R5bGU9Im51bGwiIC8+PGFwcGVhcmFuY2VzPjxhYXBwZWFyYW5jZSBuYW1lPSJfREVGQVVMVCI+PE5vcm1hbD5kYXRhOmltYWdlL3BuZztiYXNlNjQsaVZCT1J3MEtHZ29BQUFBTlNVaEVVZ0FBQUFFQUFBQUJDQVlBQUFBZkZjU0pBQUFBQVhOU1IwSUFyczRjNlFBQUFBUm5RVTFCQUFDeGp3djhZUVVBQUFBSmNFaFpjd0FBRHNNQUFBN0RBY2R2cUdRQUFBQVlkRVZZZEZOdlpuUjNZWEpsQUhCaGFXNTBMbTVsZENBMExqRXVNV01xbkVzQUFBQU5TVVJCVkJoWFkvai8vejhEQUFqOEF2NklYd2JnQUFBQUFFbEZUa1N1UW1DQzwvTm9ybWFsPjwvYWFwcGVhcmFuY2U+PC9hcHBlYXJhbmNlcz48L3dpZGdldD48d2lkZ2V0IGZpZWxkPSJUZXh0Rm9ybUZpZWxkIDM/cGFnZT0tMSZhbXA7cm9sZT1mYW1pbHkiIG5hbWU9ImFjMmViODg3LTkzZWYtMWQ4My00ZTI2LWIxOTgxYmQwMGViYSIgbW9kaWZpZWQtZGF0ZT0iRDoyMDI0MDUwNjExNTk1MCswOCcwMCciIHBhZ2U9IjIiPjxyZWN0IHgxPSIyMDMuODIiIHgyPSIzMDMuODIiIHkxPSIyMjkuMTMiIHkyPSIyNDUuMTMiIC8+PGJvcmRlciBzdHlsZT0ibnVsbCIgLz48YmFja2dyb3VuZC1jb2xvciByPSIyMTEiIGc9IjIxMSIgYj0iMjExIiBhPSIwLjUiIC8+PC93aWRnZXQ+PHdpZGdldCBmaWVsZD0iVGV4dEZvcm1GaWVsZCA0P3BhZ2U9LTEmYW1wO3JvbGU9ZmFtaWx5IiBuYW1lPSJhMjVmZTVhNC00ZDJjLTJlNDctZGRmMi1lYThlMzhhZDE3YjciIG1vZGlmaWVkLWRhdGU9IkQ6MjAyNDA1MDYxMTU5NTArMDgnMDAnIiBwYWdlPSIyIj48cmVjdCB4MT0iMjAzLjk4IiB4Mj0iMzAzLjk4IiB5MT0iMjEwLjY3IiB5Mj0iMjI2LjY3IiAvPjxib3JkZXIgc3R5bGU9Im51bGwiIC8+PGJhY2tncm91bmQtY29sb3Igcj0iMjExIiBnPSIyMTEiIGI9IjIxMSIgYT0iMC41IiAvPjwvd2lkZ2V0Pjx3aWRnZXQgZmllbGQ9IlRleHRGb3JtRmllbGQgMT9wYWdlPS0xJmFtcDtyb2xlPWZhbWlseSIgbmFtZT0iNmZjOTE1ODUtNWE5Zi1kY2IzLWFkYTItYmJlNzk5Y2NhNmE4IiBtb2RpZmllZC1kYXRlPSJEOjIwMjQwNTA2MTE1OTUwKzA4JzAwJyIgcGFnZT0iMiI+PHJlY3QgeDE9IjEzMi42MyIgeDI9IjE4Ny42MyIgeTE9IjM0NC45NSIgeTI9IjM1OS45NSIgLz48Ym9yZGVyIHN0eWxlPSJudWxsIiAvPjxiYWNrZ3JvdW5kLWNvbG9yIHI9IjIxMSIgZz0iMjExIiBiPSIyMTEiIGE9IjAuNSIgLz48L3dpZGdldD48L3BkZi1pbmZvPjxmaWVsZHM+PGZpZWxkIG5hbWU9IlBhcmVudEFJbml0aWFsP3JvbGU9ZmFtaWx5JmFtcDtwYWdlPS0xIj48dmFsdWU+PC92YWx1ZT48L2ZpZWxkPjxmaWVsZCBuYW1lPSJQYXJlbnRCU2lnbkRhdGU/cm9sZT1mYW1pbHkmYW1wO3BhZ2U9LTEmYW1wO2RlZmF1bHR2YWx1ZT1jdXJyZW50ZGF0ZSI+PHZhbHVlPjwvdmFsdWU+PC9maWVsZD48ZmllbGQgbmFtZT0iUGFyZW50QVNpZ24/cm9sZT1mYW1pbHkmYW1wO3BhZ2U9LTEiPjx2YWx1ZT48L3ZhbHVlPjwvZmllbGQ+PGZpZWxkIG5hbWU9IlBhcmVudEJTaWduP3JvbGU9ZmFtaWx5JmFtcDtwYWdlPS0xIj48dmFsdWU+PC92YWx1ZT48L2ZpZWxkPjxmaWVsZCBuYW1lPSJQYXJlbnRBU2lnbkRhdGU/cm9sZT1mYW1pbHkmYW1wO3BhZ2U9LTEmYW1wO2RlZmF1bHRWYWx1ZT1DdXJyZW50RGF0ZSI+PHZhbHVlPjwvdmFsdWU+PC9maWVsZD48ZmllbGQgbmFtZT0iU2lnbmF0dXJlRm9ybUZpZWxkIDU/cGFnZT0tMSI+PHZhbHVlPjwvdmFsdWU+PC9maWVsZD48ZmllbGQgbmFtZT0iU2lnbmF0dXJlRm9ybUZpZWxkIDY/cGFnZT0tMSI+PHZhbHVlPjwvdmFsdWU+PC9maWVsZD48ZmllbGQgbmFtZT0iVGV4dEZvcm1GaWVsZCA3P3BhZ2UtMSI+PHZhbHVlPjwvdmFsdWU+PC9maWVsZD48ZmllbGQgbmFtZT0iVGV4dEZvcm1GaWVsZCA4P3BhZ2U9LTEiPjx2YWx1ZT48L3ZhbHVlPjwvZmllbGQ+PGZpZWxkIG5hbWU9IlRleHRGb3JtRmllbGQgOT9wYWdlPS0xIj48dmFsdWU+PC92YWx1ZT48L2ZpZWxkPjxmaWVsZCBuYW1lPSJUZXh0Rm9ybUZpZWxkIDEwIj48dmFsdWU+PC92YWx1ZT48L2ZpZWxkPjxmaWVsZCBuYW1lPSJUZXh0Rm9ybUZpZWxkIDUiPjx2YWx1ZT48L3ZhbHVlPjwvZmllbGQ+PGZpZWxkIG5hbWU9IlNpZ25hdHVyZUZvcm1GaWVsZCAxNj9wYWdlPS0xIj48dmFsdWU+PC92YWx1ZT48L2ZpZWxkPjxmaWVsZCBuYW1lPSJTaWduYXR1cmVGb3JtRmllbGQgMT9wYWdlPS0xJmFtcDtyb2xlPWZhbWlseSI+PHZhbHVlPjwvdmFsdWU+PC9maWVsZD48ZmllbGQgbmFtZT0iU2lnbmF0dXJlRm9ybUZpZWxkIDI/cGFnZT0tMSZhbXA7cm9sZT1mYW1pbHkiPjx2YWx1ZT48L3ZhbHVlPjwvZmllbGQ+PGZpZWxkIG5hbWU9IlRleHRGb3JtRmllbGQgMz9wYWdlPS0xJmFtcDtyb2xlPWZhbWlseSI+PHZhbHVlPjwvdmFsdWU+PC9maWVsZD48ZmllbGQgbmFtZT0iVGV4dEZvcm1GaWVsZCA0P3BhZ2U9LTEmYW1wO3JvbGU9ZmFtaWx5Ij48dmFsdWU+PC92YWx1ZT48L2ZpZWxkPjxmaWVsZCBuYW1lPSJUZXh0Rm9ybUZpZWxkIDE/cGFnZT0tMSZhbXA7cm9sZT1mYW1pbHkiPjx2YWx1ZT48L3ZhbHVlPjwvZmllbGQ+PGZpZWxkIG5hbWU9IlNpZ25hdHVyZUZvcm1GaWVsZCA2MD9wYWdlPS0xJmFtcDtyb2xlPWFnZW5jeSI+PHZhbHVlPjwvdmFsdWU+PC9maWVsZD48L2ZpZWxkcz48YW5ub3RzPjxzcXVhcmUgcGFnZT0iMSIgcmVjdD0iNDguOCw0MTcuMDQsMjcyLjIzLDUxOS43NyIgY29sb3I9IiNFNDQyMzQiIGZsYWdzPSJwcmludCIgbmFtZT0iMDZhYWMyZTMtNzY4Yy0xZGZjLTlkODYtY2ZjZmQ5Y2ZmMDExIiB0aXRsZT0iYWRtaW5pc3RyYXRvckBtY3R0ZWNobm9sb2d5LmNvbSIgc3ViamVjdD0iUmVjdGFuZ2xlIiBkYXRlPSJEOjIwMjQwNTA2MTIwMTQ1KzA4JzAwJyIgY3JlYXRpb25kYXRlPSJEOjIwMjQwNTA2MTIwMTQzKzA4JzAwJyIgZGFzaGVzPSIiLz48c3F1YXJlIHBhZ2U9IjEiIHJlY3Q9IjM3NC45Niw0NTUuNTYsNDk1LjY3LDU1My4xNiIgY29sb3I9IiM0RTdERTkiIGZsYWdzPSJwcmludCIgbmFtZT0iZDI0NmVhYjEtZTlhMi05YmFmLTE4YTktOTZhNDNkMzI4MDAyIiB0aXRsZT0iYWRtaW5pc3RyYXRvckBtY3R0ZWNobm9sb2d5LmNvbSIgc3ViamVjdD0iUmVjdGFuZ2xlIiBkYXRlPSJEOjIwMjQwNTA2MTIwMTUwKzA4JzAwJyIgY3JlYXRpb25kYXRlPSJEOjIwMjQwNTA2MTIwMTQ5KzA4JzAwJyIgZGFzaGVzPSIiLz48ZnJlZXRleHQgcGFnZT0iMSIgcmVjdD0iMjk3LjkyLDQ1OC4xMzEsMzM2LjMyMSw0NzMuNTQiIGZsYWdzPSJwcmludCIgbmFtZT0iODg5N2U0N2YtNGIzYS1hYzU4LTk0MTAtMTAzMzBhYTM1NDIxIiB0aXRsZT0iYWRtaW5pc3RyYXRvckBtY3R0ZWNobm9sb2d5LmNvbSIgc3ViamVjdD0iRnJlZSBUZXh0IiBkYXRlPSJEOjIwMjQwNTA2MTIwMjAyKzA4JzAwJyIgd2lkdGg9IjAiIGNyZWF0aW9uZGF0ZT0iRDoyMDI0MDUwNjEyMDE1MyswOCcwMCciIFRleHRDb2xvcj0iI0U0NDIzNCIgRm9udFNpemU9IjEyIj48dHJuLWN1c3RvbS1kYXRhIGJ5dGVzPSJ7JnF1b3Q7dHJuLWF1dG8tc2l6ZS10eXBlJnF1b3Q7OiZxdW90O2F1dG8mcXVvdDssJnF1b3Q7dHJuLXdyYXBwZWQtdGV4dC1saW5lcyZxdW90OzomcXVvdDtbXCZxdW90O3Rlc3QgXCZxdW90O10mcXVvdDt9Ii8+PGNvbnRlbnRzPnRlc3Q8L2NvbnRlbnRzPjxjb250ZW50cy1yaWNodGV4dD48Ym9keT48cD48c3Bhbj50ZXN0PC9zcGFuPjwvcD48L2JvZHk+PC9jb250ZW50cy1yaWNodGV4dD48ZGVmYXVsdGFwcGVhcmFuY2U+MCAwIDAgcmcgL0hlbHZldGljYSAxMiBUZjwvZGVmYXVsdGFwcGVhcmFuY2U+PGRlZmF1bHRzdHlsZT5mb250OiBIZWx2ZXRpY2EgMTJwdDsgdGV4dC1hbGlnbjogbGVmdDsgdGV4dC12ZXJ0aWNhbC1hbGlnbjogdG9wOyBjb2xvcjogI0U0NDIzNDwvZGVmYXVsdHN0eWxlPjwvZnJlZXRleHQ+PC9hbm5vdHM+PHBhZ2VzPjxkZWZtdHggbWF0cml4PSIxLDAsMCwtMSwwLDc5MiIgLz48L3BhZ2VzPjwveGZkZj4=';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // If you are using local files:
    // * Remove the above line `showViewer();`.
    // * Change the _document field to your local filepath.
    // * Uncomment the section below, including launchWithPermission().
    // if (Platform.isIOS) {
    // showViewer(); // Permission not required for iOS.
    // } else {
    // launchWithPermission(); // Permission required for Android.
    // }
  }

  // Uncomment this if you are using local files:
  // Future<void> launchWithPermission() async {
  //  PermissionStatus permission = await Permission.storage.request();
  //  if (permission.isGranted) {
  //    showViewer();
  //  }
  // }

  // Platform messages are asynchronous, so initialize in an async method.
  Future<void> initPlatformState() async {
    String version;
    // Platform messages may fail, so use a try/catch PlatformException.
    try {
      // Initializes the PDFTron SDK, it must be called before you can use
      // any functionality.
      PdftronFlutter.initialize("your_pdftron_license_key");

      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, you want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _version = version;
    });
  }



  @override
  Widget build(BuildContext context) {
    Widget documentChild = Container();

    if (enableWidget) {
      // If using Android Widget, uncomment one of the following:
      // If using Flutter v2.3.0-17.0.pre or earlier.
      // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      // If using later Flutter versions.
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );
      documentChild = SafeArea(
          child: DocumentView(
            onCreated: _onDocumentViewCreated,
          ));
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: documentChild,
      ),
    );
  }

  // This function is used to control the DocumentView widget after it
  // has been created. The widget will not work without a void
  // Function(DocumentViewController controller) being passed to it.
  void _onDocumentViewCreated(DocumentViewController controller) async {
    Config config = new Config();

    var leadingNavCancel = startLeadingNavButtonPressedListener(() {
      // Uncomment this to quit viewer when leading navigation button is pressed:
      // this.setState(() {
      //   _showViewer = !_showViewer;
      // });

      // Show a dialog when leading navigation button is pressed.
      _showMyDialog();
    });

    await controller.openDocument(_document, config: config);

    /// importAnnotations
    String annotation = utf8.decode(base64
        .decode(_annotationStr));
    await controller.importAnnotations(annotation);

  }

  Future<void> _showMyDialog() async {
    print('hello');
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog'),
          content: SingleChildScrollView(
            child: Text('Leading navigation button has been pressed.'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
