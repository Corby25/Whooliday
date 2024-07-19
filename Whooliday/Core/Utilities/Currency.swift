//
//  Currency.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 25/06/24.
//

// list of all available currencies
class Currency: Identifiable, Codable, Hashable, CustomStringConvertible {
    let name: String
    let alpha2Code: String
    
    init(name: String, alpha2Code: String) {
        self.name = name
        self.alpha2Code = alpha2Code
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(alpha2Code)
    }
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.name == rhs.name && lhs.alpha2Code == rhs.alpha2Code
    }
    
    var description: String {
        return name
    }
    

    static var allCurrencies: [Currency] {
        [
            Currency(name: "Afghan Afghani", alpha2Code: "AFN"),
            Currency(name: "Albanian Lek", alpha2Code: "ALL"),
            Currency(name: "Algerian Dinar", alpha2Code: "DZD"),
            Currency(name: "Argentine Peso", alpha2Code: "ARS"),
            Currency(name: "Armenian Dram", alpha2Code: "AMD"),
            Currency(name: "Australian Dollar", alpha2Code: "AUD"),
            Currency(name: "Azerbaijani Manat", alpha2Code: "AZN"),
            Currency(name: "Bahamian Dollar", alpha2Code: "BSD"),
            Currency(name: "Bahraini Dinar", alpha2Code: "BHD"),
            Currency(name: "Bangladeshi Taka", alpha2Code: "BDT"),
            Currency(name: "Barbadian Dollar", alpha2Code: "BBD"),
            Currency(name: "Belarusian Ruble", alpha2Code: "BYN"),
            Currency(name: "Belize Dollar", alpha2Code: "BZD"),
            Currency(name: "Bermudian Dollar", alpha2Code: "BMD"),
            Currency(name: "Bhutanese Ngultrum", alpha2Code: "BTN"),
            Currency(name: "Bolivian Boliviano", alpha2Code: "BOB"),
            Currency(name: "Bosnia and Herzegovina Convertible Mark", alpha2Code: "BAM"),
            Currency(name: "Botswana Pula", alpha2Code: "BWP"),
            Currency(name: "Brazilian Real", alpha2Code: "BRL"),
            Currency(name: "Brunei Dollar", alpha2Code: "BND"),
            Currency(name: "Bulgarian Lev", alpha2Code: "BGN"),
            Currency(name: "Burundi Franc", alpha2Code: "BIF"),
            Currency(name: "Cambodian Riel", alpha2Code: "KHR"),
            Currency(name: "Canadian Dollar", alpha2Code: "CAD"),
            Currency(name: "Cape Verdean Escudo", alpha2Code: "CVE"),
            Currency(name: "Cayman Islands Dollar", alpha2Code: "KYD"),
            Currency(name: "Central African CFA Franc", alpha2Code: "XAF"),
            Currency(name: "Chilean Peso", alpha2Code: "CLP"),
            Currency(name: "Chinese Yuan", alpha2Code: "CNY"),
            Currency(name: "Colombian Peso", alpha2Code: "COP"),
            Currency(name: "Comorian Franc", alpha2Code: "KMF"),
            Currency(name: "Congolese Franc", alpha2Code: "CDF"),
            Currency(name: "Costa Rican Colón", alpha2Code: "CRC"),
            Currency(name: "Croatian Kuna", alpha2Code: "HRK"),
            Currency(name: "Cuban Peso", alpha2Code: "CUP"),
            Currency(name: "Czech Koruna", alpha2Code: "CZK"),
            Currency(name: "Danish Krone", alpha2Code: "DKK"),
            Currency(name: "Djiboutian Franc", alpha2Code: "DJF"),
            Currency(name: "Dominican Peso", alpha2Code: "DOP"),
            Currency(name: "East Caribbean Dollar", alpha2Code: "XCD"),
            Currency(name: "Egyptian Pound", alpha2Code: "EGP"),
            Currency(name: "Eritrean Nakfa", alpha2Code: "ERN"),
            Currency(name: "Ethiopian Birr", alpha2Code: "ETB"),
            Currency(name: "Euro", alpha2Code: "EUR"),
            Currency(name: "Falkland Islands Pound", alpha2Code: "FKP"),
            Currency(name: "Fijian Dollar", alpha2Code: "FJD"),
            Currency(name: "Gambian Dalasi", alpha2Code: "GMD"),
            Currency(name: "Georgian Lari", alpha2Code: "GEL"),
            Currency(name: "Ghanaian Cedi", alpha2Code: "GHS"),
            Currency(name: "Gibraltar Pound", alpha2Code: "GIP"),
            Currency(name: "Guatemalan Quetzal", alpha2Code: "GTQ"),
            Currency(name: "Guinean Franc", alpha2Code: "GNF"),
            Currency(name: "Guyanese Dollar", alpha2Code: "GYD"),
            Currency(name: "Haitian Gourde", alpha2Code: "HTG"),
            Currency(name: "Honduran Lempira", alpha2Code: "HNL"),
            Currency(name: "Hong Kong Dollar", alpha2Code: "HKD"),
            Currency(name: "Hungarian Forint", alpha2Code: "HUF"),
            Currency(name: "Icelandic Króna", alpha2Code: "ISK"),
            Currency(name: "Indian Rupee", alpha2Code: "INR"),
            Currency(name: "Indonesian Rupiah", alpha2Code: "IDR"),
            Currency(name: "Iranian Rial", alpha2Code: "IRR"),
            Currency(name: "Iraqi Dinar", alpha2Code: "IQD"),
            Currency(name: "Israeli New Shekel", alpha2Code: "ILS"),
            Currency(name: "Jamaican Dollar", alpha2Code: "JMD"),
            Currency(name: "Japanese Yen", alpha2Code: "JPY"),
            Currency(name: "Jordanian Dinar", alpha2Code: "JOD"),
            Currency(name: "Kazakhstani Tenge", alpha2Code: "KZT"),
            Currency(name: "Kenyan Shilling", alpha2Code: "KES"),
            Currency(name: "Kuwaiti Dinar", alpha2Code: "KWD"),
            Currency(name: "Kyrgyzstani Som", alpha2Code: "KGS"),
            Currency(name: "Lao Kip", alpha2Code: "LAK"),
            Currency(name: "Lebanese Pound", alpha2Code: "LBP"),
            Currency(name: "Lesotho Loti", alpha2Code: "LSL"),
            Currency(name: "Liberian Dollar", alpha2Code: "LRD"),
            Currency(name: "Libyan Dinar", alpha2Code: "LYD"),
            Currency(name: "Macanese Pataca", alpha2Code: "MOP"),
            Currency(name: "Malagasy Ariary", alpha2Code: "MGA"),
            Currency(name: "Malawian Kwacha", alpha2Code: "MWK"),
            Currency(name: "Malaysian Ringgit", alpha2Code: "MYR"),
            Currency(name: "Maldivian Rufiyaa", alpha2Code: "MVR"),
            Currency(name: "Mauritanian Ouguiya", alpha2Code: "MRU"),
            Currency(name: "Mauritian Rupee", alpha2Code: "MUR"),
            Currency(name: "Mexican Peso", alpha2Code: "MXN"),
            Currency(name: "Moldovan Leu", alpha2Code: "MDL"),
            Currency(name: "Mongolian Tugrik", alpha2Code: "MNT"),
            Currency(name: "Moroccan Dirham", alpha2Code: "MAD"),
            Currency(name: "Mozambican Metical", alpha2Code: "MZN"),
            Currency(name: "Myanmar Kyat", alpha2Code: "MMK"),
            Currency(name: "Namibian Dollar", alpha2Code: "NAD"),
            Currency(name: "Nepalese Rupee", alpha2Code: "NPR"),
            Currency(name: "New Taiwan Dollar", alpha2Code: "TWD"),
            Currency(name: "New Zealand Dollar", alpha2Code: "NZD"),
            Currency(name: "Nicaraguan Córdoba", alpha2Code: "NIO"),
            Currency(name: "Nigerian Naira", alpha2Code: "NGN"),
            Currency(name: "North Korean Won", alpha2Code: "KPW"),
            Currency(name: "Norwegian Krone", alpha2Code: "NOK"),
            Currency(name: "Omani Rial", alpha2Code: "OMR"),
            Currency(name: "Pakistani Rupee", alpha2Code: "PKR"),
            Currency(name: "Panamanian Balboa", alpha2Code: "PAB"),
            Currency(name: "Papua New Guinean Kina", alpha2Code: "PGK"),
            Currency(name: "Paraguayan Guarani", alpha2Code: "PYG"),
            Currency(name: "Peruvian Sol", alpha2Code: "PEN"),
            Currency(name: "Philippine Peso", alpha2Code: "PHP"),
            Currency(name: "Polish Zloty", alpha2Code: "PLN"),
            Currency(name: "Qatari Riyal", alpha2Code: "QAR"),
            Currency(name: "Romanian Leu", alpha2Code: "RON"),
            Currency(name: "Russian Ruble", alpha2Code: "RUB"),
            Currency(name: "Rwandan Franc", alpha2Code: "RWF"),
            Currency(name: "Saint Helena Pound", alpha2Code: "SHP"),
            Currency(name: "Samoan Tala", alpha2Code: "WST"),
            Currency(name: "Sao Tome and Principe Dobra", alpha2Code: "STN"),
            Currency(name: "Saudi Riyal", alpha2Code: "SAR"),
            Currency(name: "Serbian Dinar", alpha2Code: "RSD"),
            Currency(name: "Seychellois Rupee", alpha2Code: "SCR"),
            Currency(name: "Sierra Leonean Leone", alpha2Code: "SLL"),
            Currency(name: "Singapore Dollar", alpha2Code: "SGD"),
            Currency(name: "Solomon Islands Dollar", alpha2Code: "SBD"),
            Currency(name: "Somali Shilling", alpha2Code: "SOS"),
            Currency(name: "South African Rand", alpha2Code: "ZAR"),
            Currency(name: "South Korean Won", alpha2Code: "KRW"),
            Currency(name: "South Sudanese Pound", alpha2Code: "SSP"),
            Currency(name: "Sri Lankan Rupee", alpha2Code: "LKR"),
            Currency(name: "Sudanese Pound", alpha2Code: "SDG"),
            Currency(name: "Surinamese Dollar", alpha2Code: "SRD"),
            Currency(name: "Swazi Lilangeni", alpha2Code: "SZL"),
            Currency(name: "Swedish Krona", alpha2Code: "SEK"),
            Currency(name: "Swiss Franc", alpha2Code: "CHF"),
            Currency(name: "Syrian Pound", alpha2Code: "SYP"),
            Currency(name: "Tajikistani Somoni", alpha2Code: "TJS"),
            Currency(name: "Tanzanian Shilling", alpha2Code: "TZS"),
            Currency(name: "Thai Baht", alpha2Code: "THB"),
            Currency(name: "Tongan Pa'anga", alpha2Code: "TOP"),
            Currency(name: "Trinidad and Tobago Dollar", alpha2Code: "TTD"),
            Currency(name: "Tunisian Dinar", alpha2Code: "TND"),
            Currency(name: "Turkish Lira", alpha2Code: "TRY"),
            Currency(name: "Turkmenistan Manat", alpha2Code: "TMT"),
            Currency(name: "Ugandan Shilling", alpha2Code: "UGX"),
            Currency(name: "Ukrainian Hryvnia", alpha2Code: "UAH"),
            Currency(name: "United Arab Emirates Dirham", alpha2Code: "AED"),
            Currency(name: "United States Dollar", alpha2Code: "USD"),
            Currency(name: "Uruguayan Peso", alpha2Code: "UYU"),
            Currency(name: "Uzbekistan Som", alpha2Code: "UZS"),
            Currency(name: "Vanuatu Vatu", alpha2Code: "VUV"),
            Currency(name: "Venezuelan Bolívar", alpha2Code: "VES"),
            Currency(name: "Vietnamese Dong", alpha2Code: "VND"),
            Currency(name: "Yemeni Rial", alpha2Code: "YER"),
            Currency(name: "Zambian Kwacha", alpha2Code: "ZMW"),
            Currency(name: "Zimbabwean Dollar", alpha2Code: "ZWL")
        ]
    }
}
