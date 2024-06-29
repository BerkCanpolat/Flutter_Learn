import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/ui/views/detay_sayfa.dart';
import 'package:kisiler_uygulamasi/ui/views/kayit_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;

  Future<void> ara(String aramaKelimesi) async {
    print("Kişi Ara: $aramaKelimesi");
  }


  Future<List<Kisiler>> kisileriYukle() async {
    var kisilerListesi = <Kisiler>[];
    var k1 = Kisiler(kisi_id: 1, kisi_ad: "Ahmet", kisi_tel: "111111");
    var k2 = Kisiler(kisi_id: 2, kisi_ad: "Berk", kisi_tel: "5451234");
    var k3 = Kisiler(kisi_id: 3, kisi_ad: "Ali", kisi_tel: "32432423");

    kisilerListesi.add(k1);
    kisilerListesi.add(k2);
    kisilerListesi.add(k3);

    return kisilerListesi;
  }

    Future<void> sil(int kisi_id) async {
    print("Kişi Sil: $kisi_id");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu ? 
        TextField(
          decoration: const InputDecoration(hintText: "Ara"),
          onChanged: (aramaSonucu){
            ara(aramaSonucu);
          },
        ) : 
        const Text("Kişiler"),
        actions: [
          aramaYapiliyorMu ?
          IconButton(
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = false;
              });
            }, 
            icon: const Icon(Icons.clear),
            ) : IconButton(
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = true;
              });
            }, 
            icon: const Icon(Icons.search),
            ),
        ],
        ),
      body: FutureBuilder<List<Kisiler>>(
        future: kisileriYukle(), 
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            var kisilerListesi = snapshot.data;
            return ListView.builder(
              itemCount: kisilerListesi!.length,
              itemBuilder: (context, index) {
                var kisi = kisilerListesi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetaySayfa(kisi: kisi)))
                    .then((value) {

                    });
                  },
                  child: Card(
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(kisi.kisi_ad, style: const TextStyle(fontSize: 20),),
                                Text(kisi.kisi_tel),
                              ],
                            ),
                          ),
                          IconButton(onPressed: (){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${kisi.kisi_ad} Silinsin mi?"),
                                action: SnackBarAction(
                                  label: "Evet", 
                                  onPressed: (){
                                    sil(kisi.kisi_id);
                                  }
                                ),
                              ),
                            );
                          }, icon: Icon(Icons.clear, color: Colors.black54,),),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center();
          }
        },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => KayitSayfa()))
          .then((value) {
            print("Anasayfaya Dönüldü");
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}