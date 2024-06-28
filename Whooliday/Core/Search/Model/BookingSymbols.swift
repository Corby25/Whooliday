//
//  BookingSymbols.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 28/06/24.
//

// HotelTypeSymbols.swift

import Foundation

func getHotelTypeSymbol(for hotelTypeId: Int) -> String {
    switch hotelTypeId {
    case 201: return "building.2" // Apartments
    case 202: return "house" // Guest accommodation
    case 203: return "bed.double" // Hostels
    case 204: return "building" // Hotels
    case 205: return "house.lodge" // Motels
    case 206: return "sun.horizon" // Resorts
    case 207: return "house.fill" // Residences
    case 208: return "cup.and.saucer" // Bed and breakfasts
    case 209: return "house.lodge" // Ryokans
    case 210: return "leaf" // Farm stays
    case 212: return "tent" // Holiday parks
    case 213: return "house" // Villas
    case 214: return "figure.hiking" // Campsites
    case 215: return "sailboat" // Boats
    case 216: return "house" // Guest houses
    case 217: return "questionmark.circle" // Uncertain
    case 218: return "mug" // Inns
    case 219: return "building.columns" // Aparthotels
    case 220: return "house" // Holiday homes
    case 221: return "tree" // Lodges
    case 222: return "house.fill" // Homestays
    case 223: return "house" // Country houses
    case 224: return "tent" // Luxury tents
    case 225: return "square.grid.3x3.fill" // Capsule hotels
    case 226: return "heart" // Love hotels
    case 227: return "building.columns.fill" // Riads
    case 228: return "snow" // Chalets
    case 229: return "building.2.fill" // Condos
    case 230: return "house" // Cottages
    case 231: return "dollarsign.circle" // Economy hotels
    case 232: return "house" // Gites
    case 233: return "heart.circle" // Health resorts
    case 234: return "ferry" // Cruises
    case 235: return "graduationcap" // Student accommodation
    default: return "building" // Default symbol
    }
}



func getHotelFacilitySymbolAndName(for facilityTypeId: Int) -> (symbol: String, name: String) {
    switch facilityTypeId {
    case 2: return ("car", "Parcheggio")
    case 3: return ("fork.knife", "Ristorante")
    case 4: return ("pawprint", "Animali ammessi")
    case 5: return ("tray", "Servizio in camera")
    case 6: return ("person.3", "Strutture per riunioni/banchetti")
    case 7: return ("wineglass", "Bar")
    case 8: return ("clock", "Reception 24 ore su 24")
    case 9: return ("tennis.racket", "Campo da tennis")
    case 10: return ("heat", "Sauna")
    case 11: return ("dumbbell", "Centro fitness")
    case 12: return ("golf", "Campo da golf (entro 3 km)")
    case 14: return ("leaf", "Giardino")
    case 15: return ("sun.haze", "Terrazza")
    case 16: return ("nosign", "Camere non fumatori")
    case 17: return ("airplane", "Navetta aeroportuale")
    case 19: return ("fish", "Pesca")
    case 20: return ("briefcase", "Centro business")
    case 21: return ("figure.child", "Servizio di babysitting/assistenza bambini")
    case 22: return ("washer", "Lavanderia")
    case 23: return ("dryer", "Lavaggio a secco")
    case 24: return ("croissant", "Colazione continentale")
    case 25: return ("figure.roll", "Strutture per ospiti disabili")
    case 26: return ("snow", "Sci")
    case 27: return ("scissors", "Barbiere/salone di bellezza")
    case 28: return ("house", "Camere familiari")
    case 29: return ("gamecontroller", "Sala giochi")
    case 30: return ("dollarsign.circle", "Casinò")
    case 43: return ("bed.double", "Colazione in camera")
    case 44: return ("iron", "Servizio stireria")
    case 47: return ("network", "Servizi internet")
    case 48: return ("arrow.up.arrow.down", "Ascensore")
    case 49: return ("checkmark.rectangle", "Check-in/check-out express")
    case 50: return ("sun.max", "Solarium")
    case 51: return ("lock", "Cassaforte")
    case 53: return ("banknote", "Cambio valuta")
    case 54: return ("sparkles", "Centro benessere")
    case 55: return ("hand.draw", "Massaggi")
    case 56: return ("figure.walk", "Parco giochi per bambini")
    case 57: return ("circle.grid.3x3", "Biliardo")
    case 58: return ("triangle", "Ping pong")
    case 59: return ("music.mic", "Karaoke")
    case 61: return ("wind", "Windsurf")
    case 62: return ("target", "Freccette")
    case 63: return ("bubble.right", "Vasca idromassaggio")
    case 64: return ("ear", "Camere insonorizzate")
    case 69: return ("figure.wave", "Canoa")
    case 70: return ("figure.walk", "Escursionismo")
    case 71: return ("building.columns", "Cappella/santuario")
    case 72: return ("flame", "Barbecue")
    case 73: return ("bag", "Pranzi al sacco")
    case 75: return ("car.2", "Noleggio auto")
    case 76: return ("bicycle", "Ciclismo")
    case 77: return ("circle.circle", "Bowling")
    case 78: return ("info.circle", "Banco escursioni")
    case 79: return ("cloud.fog", "Hammam")
    case 80: return ("thermometer", "Riscaldamento")
    case 81: return ("doc.on.doc", "Fax/fotocopiatrice")
    case 82: return ("water.waves", "Immersioni subacquee")
    case 86: return ("figure.walk", "Equitazione")
    case 87: return ("square", "Squash")
    case 90: return ("goggles", "Snorkeling")
    case 91: return ("bag", "Deposito bagagli")
    case 96: return ("wifi", "WiFi")
    case 97: return ("flag", "Minigolf")
    case 99: return ("snow", "Deposito sci")
    case 100: return ("snowflake", "Scuola di sci")
    case 101: return ("leaf.arrow.circlepath", "Camera anallergica")
    case 103: return ("drop", "Piscina coperta")
    case 104: return ("sun.max", "Piscina all'aperto")
    case 108: return ("smoke", "Struttura interamente non fumatori")
    case 109: return ("air.conditioner.vertical", "Aria condizionata")
    case 110: return ("smoke", "Area fumatori")
    case 111: return ("dollarsign.square", "Bancomat")
    case 114: return ("umbrella.beach", "Spiaggia privata")
    case 115: return ("fork.knife", "Ristorante (à la carte)")
    case 116: return ("fork.knife", "Ristorante (a buffet)")
    case 117: return ("cup.and.saucer", "Snack bar")
    case 118: return ("sun.haze", "Terrazza solarium")
    case 119: return ("drop", "Piscina all'aperto (tutto l'anno)")
    case 120: return ("drop", "Piscina all'aperto (stagionale)")
    case 121: return ("drop", "Piscina coperta (tutto l'anno)")
    case 122: return ("drop", "Piscina coperta (stagionale)")
    case 124: return ("person.crop.circle.badge.questionmark", "Servizio concierge")
    case 125: return ("person.2", "Staff di animazione")
    case 126: return ("music.note", "Discoteca/DJ")
    case 127: return ("checklist", "Check-in/check-out privati")
    case 128: return ("bus", "Navetta (gratuita)")
    case 129: return ("bus", "Navetta (a pagamento)")
    case 130: return ("skis", "Noleggio attrezzature sciistiche in loco")
    case 131: return ("ticket", "Vendita skipass")
    case 132: return ("figure.skiing", "Accesso diretto alle piste da sci")
    case 133: return ("leaf", "Menù per diete particolari (su richiesta)")
    case 134: return ("scissors", "Pressa pantaloni")
    case 135: return ("cup.and.saucer", "Distributore automatico di bevande")
    case 136: return ("cube", "Distributore automatico di snack")
    case 137: return ("water.waves", "Impianti sport acquatici in loco")
    case 138: return ("thermometer.sun", "Bagno termale")
    case 139: return ("airplane", "Navetta aeroportuale (gratuita)")
    case 140: return ("airplane", "Navetta aeroportuale (a pagamento)")
    case 141: return ("cooktop", "Cucina in comune")
    case 142: return ("lock", "Armadi")
    case 143: return ("tv", "Sala comune/zona TV")
    case 144: return ("figure.2.and.child", "Club per bambini")
    case 145: return ("cart", "Minimarket in loco")
    case 146: return ("beach.umbrella", "Fronte spiaggia")
    case 147: return ("music.mic", "Intrattenimento serale")
    case 148: return ("water.waves", "Parco acquatico")
    case 149: return ("person.crop.circle", "Solo adulti")
    case 158: return ("bed.double", "Pulizie giornaliere")
    case 159: return ("cart", "Consegna generi alimentari")
    case 164: return ("wifi", "WiFi a pagamento")
    case 166: return ("leaf", "Vasca all'aperto")
    case 167: return ("figure.walk", "Bagno pubblico")
    case 168: return ("water.waves", "Scivolo d'acqua")
    case 169: return ("circle", "Giocattoli da piscina")
    case 170: return ("puzzlepiece", "Giochi da tavolo/puzzle")
    case 172: return ("house", "Area giochi interna")
    case 173: return ("figure.walk", "Attrezzature giochi all'aperto per bambini")
    case 174: return ("lock", "Cancelletti di sicurezza per bambini")
    case 176: return ("fork.knife", "Menu per bambini")
    case 177: return ("fork.knife", "Buffet per bambini")
    case 179: return ("lock.car", "Parcheggio custodito")
    case 181: return ("car", "Garage")
    case 182: return ("bolt.car", "Stazione di ricarica per veicoli elettrici")
    case 183: return ("ticket", "Biglietti per i mezzi pubblici")
    case 185: return ("figure.roll", "Accessibile in sedia a rotelle")
    case 186: return ("figure.roll", "Toilette con maniglioni")
    case 187: return ("figure.roll", "Toilette a livello superiore")
    case 188: return ("sink", "Lavandino basso nel bagno")
    case 189: return ("bell", "Cordino di emergenza nel bagno")
    case 192: return ("drop", "Piscina sul tetto")
    case 193: return ("drop", "Piscina a sfioro")
    case 194: return ("drop", "Piscina con vista")
    case 195: return ("thermometer.sun", "Piscina riscaldata")
    case 196: return ("drop", "Piscina salata")
    case 197: return ("drop", "Piscina a immersione")
    case 199: return ("wineglass", "Bar in piscina")
    case 200: return ("drop", "Fondo basso")
    case 201: return ("drop", "Copertura per piscina")
    case 203: return ("wineglass", "Vino/champagne")
    case 205: return ("leaf", "Frutta")
    case 209: return ("airplane.arrival", "Navetta aeroportuale (arrivo)")
    case 210: return ("airplane.departure", "Navetta aeroportuale (partenza)")
    case 211: return ("hand.point.up.braille", "Aid visivi: Braille")
    case 212: return ("hand.tap", "Aid visivi: Segnaletica tattile")
    case 213: return ("ear", "Guida uditiva")
    case 214: return ("figure.walk", "Passeggini")
    case 215: return ("tennis.racket", "Attrezzatura da tennis")
    case 216: return ("figure.badminton", "Attrezzatura da badminton")
    case 217: return ("pawprint", "Cestino per animali domestici")
    case 218: return ("pawprint", "Ciotole per animali domestici")
    case 219: return ("cup.and.saucer", "Caffetteria in loco")
    case 220: return ("beach.umbrella", "Lettini o sedie da spiaggia")
    case 221: return ("beach.umbrella", "Ombrelloni da spiaggia")
    case 222: return ("chair", "Arredamento esterno")
    case 223: return ("fence", "Recinzione intorno alla piscina")
    case 224: return ("leaf", "Area picnic")
    case 225: return ("flame", "Camino all'aperto")
    case 226: return ("scissors", "Servizi di bellezza")
    case 227: return ("face.smiling", "Trattamenti viso")
    case 228: return ("scissors", "Servizi di depilazione")
    case 229: return ("face.smiling", "Servizi di trucco")
    case 230: return ("scissors", "Trattamenti per capelli")
    case 231: return ("hand.point.up", "Manicure")
    case 232: return ("foot", "Pedicure")
    case 233: return ("scissors", "Taglio di capelli")
    case 234: return ("paintpalette", "Colorazione dei capelli")
    case 235: return ("scissors", "Acconciature")
    case 236: return ("figure.walk", "Trattamenti corpo")
    case 237: return ("hand.draw", "Scrubs corporei")
    case 238: return ("person.crop.rectangle", "Fasciatura corporea")
    case 239: return ("lightbulb", "Terapia della luce")
    case 240: return ("sparkles", "Strutture spa")
    case 241: return ("cloud.fog", "Bagno turco")
    case 242: return ("bed.double", "Area lounge/relax spa")
    case 243: return ("foot", "Bagno ai piedi")
    case 244: return ("gift", "Pacchetti spa/benessere")
    case 245: return ("hand.draw", "Massaggio alla schiena")
    case 246: return ("person.crop.circle", "Massaggio al collo")
    case 247: return ("foot", "Massaggio ai piedi")
    case 248: return ("heart", "Massaggio di coppia")
    case 249: return ("person.crop.circle", "Massaggio alla testa")
    case 250: return ("hand.raised", "Massaggio alle mani")
    case 251: return ("figure.walk", "Massaggio completo del corpo")
    case 252: return ("chair", "Sedia massaggiante")
    case 253: return ("figure.walk", "Fitness")
    case 254: return ("figure.mind.and.body", "Lezioni di yoga")
    case 255: return ("figure.walk", "Lezioni di fitness")
    case 256: return ("person.crop.circle", "Personal trainer")
    case 257: return ("lock", "Spogliatoi fitness/spa")
    case 258: return ("drop", "Piscina per bambini")
    case 301: return ("drop", "Piscina")
    case 302: return ("beach.umbrella", "Spiaggia")
    case 304: return ("bus", "Servizio navetta")
    case 306: return ("car", "Safari")
    case 400: return ("photo", "Gallerie d'arte temporanee")
    case 401: return ("figure.walk", "Pub crawl")
    case 402: return ("mic", "Spettacoli di stand-up comedy")
    case 403: return ("film", "Serate cinematografiche")
    case 404: return ("figure.walk", "Tour a piedi")
    case 405: return ("bicycle", "Tour in bicicletta")
    case 406: return ("fork.knife", "Serate a tema")
    case 407: return ("clock", "Aperitivo")
    case 408: return ("book", "Tour o classe sulla cultura locale")
    case 409: return ("flame", "Lezioni di cucina")
    case 410: return ("music.mic", "Musica dal vivo/spettacoli")
    case 411: return ("sportscourt", "Eventi sportivi in diretta (trasmessi)")
    case 412: return ("target", "Tiro con l'arco")
    case 413: return ("figure.walk", "Aerobica")
    case 414: return ("number.circle", "Bingo")
    case 418: return ("lock", "Sicurezza 24 ore su 24")
    case 419: return ("key", "Accesso con chiave")
    case 420: return ("creditcard", "Pagamento con carta di credito")
    case 421: return ("bell", "Allarme di sicurezza")
    case 422: return ("smoke", "Allarmi antincendio")
    case 423: return ("camera", "Telecamere CCTV nelle aree comuni")
    case 424: return ("camera", "Telecamere CCTV all'esterno della struttura")
    case 425: return ("flame", "Estintori")
    case 431: return ("thermometer.sun", "Bagno caldo/sorgente termale")
    case 432: return ("drop", "Bagno privato")
    case 433: return ("drop", "Piscina")
    case 447: return ("bicycle", "Noleggio biciclette")
    case 449: return ("sparkles", "Utilizzo di prodotti per la pulizia efficaci contro il Coronavirus")
    case 450: return ("washer", "Biancheria, asciugamani e lavanderia lavati secondo le linee guida delle autorità locali")
    case 451: return ("sparkles", "Alloggi per gli ospiti disinfettati tra un soggiorno e l'altro")
    case 452: return ("lock", "Alloggi per gli ospiti sigillati dopo la pulizia")
    case 453: return ("figure.walk", "Distanziamento fisico nelle aree ristorazione")
    case 454: return ("tray", "Il cibo può essere consegnato negli alloggi degli ospiti")
    case 455: return ("shield", "Il personale segue tutti i protocolli di sicurezza come indicato dalle autorità locali")
    case 456: return ("nosign", "Rimozione della cartoleria condivisa come menu stampati, riviste, penne e carta")
    case 459: return ("cross.case", "Kit di pronto soccorso disponibile")
    case 460: return ("person.crop.circle", "Check-in/check-out senza contatto")
    case 461: return ("creditcard", "Pagamento senza contanti disponibile")
    case 462: return ("rectangle.split.3x1", "Rispetto delle regole di distanziamento fisico")
    case 463: return ("app", "App mobile per il servizio in camera")
    case 464: return ("rectangle.on.rectangle", "Schermi o barriere fisiche poste tra il personale e gli ospiti nelle aree appropriate")
    case 465: return ("doc", "Fattura fornita")
    case 466: return ("broom", "La struttura è pulita da aziende di pulizia professionali")
    case 467: return ("sparkles", "Tutte le stoviglie come piatti, posate, bicchieri e altro sono stati sanificati")
    case 468: return ("hand.raised", "Gli ospiti hanno la possibilità di cancellare eventuali servizi di pulizia durante il soggiorno")
    case 484: return ("bag", "Contenitori da asporto per la colazione")
    case 485: return ("lock.shield", "Il cibo consegnato è coperto in modo sicuro")
    case 486: return ("stethoscope", "Accesso a professionisti sanitari")
    case 487: return ("thermometer", "Termometri forniti dalla struttura per gli ospiti")
    case 488: return ("facemask", "Mascherine a disposizione degli ospiti")
    default: return ("none", "none") // Simbolo predefinito
        
    }
}
    

        
