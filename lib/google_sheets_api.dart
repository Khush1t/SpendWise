import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "spendwise-392813",
  "private_key_id": "3081215e02f74f7d179680a8b03a1b9928e1e90a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC0YWZo/N2pE0Wo\nhCEEeBPCEBlD/NGohU829eDprDlmYAOGQU4lak7SNZiJu7lWi1KlwlYFh55PLSfF\nvCwVfiaJjsG1bKPx1rDiSDdTVtjdO+rjsXw+1F0GRBanqqBYsob3S7XBzaGo/ZZC\nwop6evgmGisJXDVlLfOIrN+HjFBlNZUAxVoekoebyFltz4ydhF5sjNXZAMObxGzF\n8fEVweKRq1YQbHOVAzXjO9GzH6eWOGbTBm1u9AeEWmP4Ck+Fc+sJLySZferskbG0\n9sUYNQTdn6StZt6fexAxC7MxaS+eEBW3U+T26mmHh3mK1mjKhGzpqsUvzVdEIWwO\nZp2SDND7AgMBAAECggEAQAd5AliMWGmKZwSr8bmsDc2IIm2agK79jP1fvqLPZ0s6\nxQvmcPqZCx5STMXxxspC5qsivOjEpcdaIGMo5OI4TMj7cuqjEYQLmu9WkEM6TOHp\ngbStbWIVuVUvE4pKS+Hnbd4WoTpcoa+OiJkk7dA7yM6uKy7rl0Rl98ShvixtF1eC\npyQ2f+hZTNQ1QsiP8n6Pl1jT3OWe90MftKjCZbBTAmM5TReOjVLK2QmyCC6leHBT\n+4XlOJuxyhJJR2JixNls/2otCO7Da1IWhKmSbHr3xOcD79rObZlvvzuNKMM2W0JZ\neoBClfc99Qn8kjb3MuqrKbR51MhTjKDP6h/EHGlrlQKBgQDfK3TrGvEfFVCjENB8\nvikXwmAZu+8FTazhIk0jipoWoZmCBFV4GHvoUIX4m8oaSJJQTjey2uRGsDvMXsLk\nRAJQcgxpySZiibRXeF9LUG/DnK8ly0roET4DWE+Z+YXv1IV4dXrJjtjmv9ZBnXYD\n/cZ3S03N6y7yYVQPTJ6Q/5KIdQKBgQDO6oEroKzpPGAKfeEbB8DjrnejoystDHo7\nomf5xUto+ox5sULmMb6dVD5co36rB9muyxUue1Xt3z0TbzlXuzdFfACjhwQ+C5gv\ns7q8/So2MLGhJZGc9vJMmqJEV0jYe++5qqgQribOHkqtuKNB2IBsE5MYkHyQIjMp\nyRNJ8nJFrwKBgFut85Md905IqF7E6pFEYYdEL8yCmxe3qDy4pa3jI5gGfRSfiSkU\nDdsLMW5HOciAZbMd3t3X9I1hmr9DcpbppXW81IKkwuMaJP8GEUfUXIWkmYNSN4yM\ngMhJADKGAlLbIJWy1WV2DH8G8hL0h+Xt3Bln0yez5Q5nk2vRkxaIF399AoGAJOoZ\nWVs0/fdTewuyGUxs0THTDlKR5VuQgwsaWaklJvlsDlndgYvmYdMhvQ0+D+06nMCG\nauB+GA33q3vwUwKHfdH9my7/RsJyyC/cZNMVsM1HI2S8cbBs0dXUlTStPlH+FrWn\nfjJTofotgIisN5cUcjObzooYbu5rCk1hL5QdZukCgYB2/g7rNGnJABNDpX/r1Cm+\nBm4k6Q4HVTE1bZ/lqBd+2Xh7gHYuRRuA6lzpGVGSRiTl4HqbptHijQEeIn0AoxMP\nNA/bToP8ATWWEbsGWMNN7SZIvUKlqioQBJkuf96GdivKiAWjyeYz8ZPnP0VxY8xk\noBeBiBtD8V1ezr4sV/GcFw==\n-----END PRIVATE KEY-----\n",
  "client_email": "spendwise@spendwise-392813.iam.gserviceaccount.com",
  "client_id": "106746663376412978884",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/spendwise%40spendwise-392813.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1EO2Fx6Qctptu59cNt0XNDA_lF2C8rFWkwW1KJTMKMTI';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'Income' : 'Expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'Income' : 'Expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'Income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'Expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
