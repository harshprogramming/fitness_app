
import 'package:flutter/material.dart';
import 'dart:math' as math;
class SimpleBarChart extends StatelessWidget{
  const SimpleBarChart({super.key, required this.values, this.labels});
  final List<double> values; final List<String>? labels;
  @override
  Widget build(BuildContext context){
    final maxVal = values.isEmpty ? 1.0 : values.reduce(math.max).clamp(1.0, double.infinity);
    return AspectRatio(aspectRatio:16/9, child:CustomPaint(painter:_BarPainter(values,labels,maxVal)));
  }
}
class _BarPainter extends CustomPainter{
  _BarPainter(this.values,this.labels,this.maxVal);
  final List<double> values; final List<String>? labels; final double maxVal;
  @override
  void paint(Canvas c, Size s){
    final p=Paint()..style=PaintingStyle.fill; final bw = s.width/(values.length*2+1);
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for(var i=0;i<values.length;i++){
      final x = bw*(1+i*2); final h=(values[i]/maxVal)*(s.height*0.75);
      final r = Rect.fromLTWH(x, s.height-h-20, bw, h);
      p.color=Colors.blueGrey; c.drawRect(r,p);
      tp.text=TextSpan(text:values[i].toStringAsFixed(0),style:const TextStyle(fontSize:10,color:Colors.black87)); tp.layout(); tp.paint(c, Offset(x, s.height-h-35));
      if(labels!=null && i<labels!.length){ tp.text=TextSpan(text:labels![i],style:const TextStyle(fontSize:10,color:Colors.black54)); tp.layout(maxWidth:bw*2); tp.paint(c, Offset(x-bw*0.3, s.height-16)); }
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>true;
}
