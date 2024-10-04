import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../Model/Order/order_summary.dart';

class LineChartSample extends StatefulWidget {
  @override
  _LineChartSampleState createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  int? selectedYear;

  List<int> years = List.generate(5, (index) => DateTime.now().year - index);

  // Dữ liệu mẫu
  List<OrderSummary> orderSummaries = [
    OrderSummary(year: 2023, month: 1, total: 500),
    OrderSummary(year: 2023, month: 2, total: 400),
    OrderSummary(year: 2023, month: 3, total: 600),
    OrderSummary(year: 2023, month: 4, total: 700),
    OrderSummary(year: 2023, month: 5, total: 300),
    OrderSummary(year: 2023, month: 6, total: 500),
    OrderSummary(year: 2023, month: 7, total: 450),
    OrderSummary(year: 2024, month: 1, total: 550),
    OrderSummary(year: 2024, month: 2, total: 600),
    OrderSummary(year: 2024, month: 3, total: 700),
  ];

  // Hàm lấy dữ liệu chi tiêu theo năm
  List<double> getMonthlyExpensesByYear(int year) {
    List<double> monthlyExpenses = List.filled(12, 0.0); // Tạo danh sách rỗng cho 12 tháng
    orderSummaries.forEach((order) {
      if (order.year == year) {
        monthlyExpenses[order.month - 1] += order.total; // Cộng tổng chi tiêu theo tháng
      }
    });
    return monthlyExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<int>(
                  hint: Text('Chọn năm'),
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedYear = newValue;
                    });
                  },
                  items: years.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Chú thích trục Y
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Chi tiêu', // Chú thích cho trục Y
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height:20,),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: _buildChart(),
            ),
            SizedBox(height: 10),
            // Chú thích trục X
            Align(
              alignment: Alignment.center,
              child: Text(
                'Tháng', // Chú thích cho trục X
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm xây dựng biểu đồ
  Widget _buildChart() {
    if (selectedYear == null) {
      return Center(child: Text('Vui lòng chọn năm.'));
    }

    // Lấy dữ liệu chi tiêu của các tháng cho năm đã chọn
    List<double> monthlyExpenses = getMonthlyExpensesByYear(selectedYear!);

    // Tạo dữ liệu cho biểu đồ
    List<FlSpot> spots = List.generate(12, (index) => FlSpot(index.toDouble(), monthlyExpenses[index]));

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false, // Không hiển thị tiêu đề cho trục trên
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false
            )
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(' ${(value + 1).toInt()}', style: TextStyle(fontSize: 12)),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 100,
              reservedSize: 40,
              getTitlesWidget: leftTitleWidgets,
            ),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black, width: 1)),
        minX: 0,
        maxX: 11, // 12 tháng
        minY: 0,
        maxY: monthlyExpenses.reduce((a, b) => a > b ? a : b) + 100, // Giá trị lớn nhất + 100 để có khoảng trống
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị tiêu đề cột bên trái
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
    return Text(value.toInt().toString(), style: style, textAlign: TextAlign.left);
  }
}
