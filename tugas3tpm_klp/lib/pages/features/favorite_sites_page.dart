import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Site {
  final String name;
  final String imagePath;
  final String url;
  bool isFavorite;

  Site({
    required this.name,
    required this.imagePath,
    required this.url,
    this.isFavorite = false,
  });
}

class FavoriteSitesPage extends StatefulWidget {
  @override
  _FavoriteSitesPageState createState() => _FavoriteSitesPageState();
}

class _FavoriteSitesPageState extends State<FavoriteSitesPage> {
  bool showFavorites = false;

  List<Site> sites = [
    Site(name: "Detik", imagePath: "assets/image/situs/detik.jpg", url: "https://www.detik.com"),
    Site(name: "Kompas", imagePath: "assets/image/situs/kompas.png", url: "https://www.kompas.com"),
    Site(name: "CNN Indonesia", imagePath: "assets/image/situs/cnnIndo.png", url: "https://www.cnnindonesia.com"),
    Site(name: "Liputan6", imagePath: "assets/image/situs/liputan6.jpg", url: "https://www.liputan6.com"),
    Site(name: "Tribunnews", imagePath: "assets/image/situs/tribun.png", url: "https://www.tribunnews.com"),
    Site(name: "Tempo", imagePath: "assets/image/situs/tempo.png", url: "https://www.tempo.co"),
    Site(name: "Okezone", imagePath: "assets/image/situs/okezone.png", url: "https://www.okezone.com"),
    Site(name: "IDN Times", imagePath: "assets/image/situs/idntimes.webp", url: "https://www.idntimes.com"),
  ];

  void _toggleFavorite(int index) {
    setState(() {
      sites[index].isFavorite = !sites[index].isFavorite;
    });
  }

  void _toggleView() {
    setState(() {
      showFavorites = !showFavorites;
    });
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Site> displayedSites = showFavorites ? sites.where((site) => site.isFavorite).toList() : sites;

    return Scaffold(
      appBar: AppBar(
        title: Text(showFavorites ? "Favorit Saya" : "Situs Favorit"),
        leading: showFavorites
            ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _toggleView
            )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: displayedSites.isEmpty
                ? Center(
                  child: Text(
                    "Tidak ada favorit!",
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold
                    )
                  )
                )
                : GridView.builder(
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: displayedSites.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(displayedSites[index].imagePath, height: 60, fit: BoxFit.contain),
                            SizedBox(height: 8),
                            Text(displayedSites[index].name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _launchURL(displayedSites[index].url),
                              child: Text("Kunjungi Situs"),
                            ),
                            IconButton(
                              icon: Icon(
                                displayedSites[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () => _toggleFavorite(sites.indexOf(displayedSites[index])),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (!showFavorites)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _toggleView,
                child: Text("Favorit Saya"),
              ),
            ),
        ],
      ),
    );
  }
}
