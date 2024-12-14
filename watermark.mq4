//+------------------------------------------------------------------+
//|                                               Watermark.mq4       |
//|                        Copyright 2024, KorkiiGOD                  |
//|                                                                   |
//+------------------------------------------------------------------+
#property indicator_chart_window

input int FontSize = 50;                     // Betűméret
input color TextColor = clrLightGray;        // Betűszín
input int XOffset = -200;                    // X eltolás a középponttól
input int YOffset = -200;                    // Y eltolás a középponttól

input string CustomText = "KorkiiiFX";                // Egyedi szöveg (üresen maradhat, ha nem szükséges)
input bool ShowCustomText = true;           // Egyedi szöveg megjelenítése
input int CustomFontSize = 15;               // Egyedi szöveg betűmérete
input int CustomXOffset = 0;               // Egyedi szöveg X eltolása
input int CustomYOffset = 0;               // Egyedi szöveg Y eltolása
input color CustomTextColor = clrWhite;      // Egyedi szöveg színe

// OnInit funkció (egyszer fut le, amikor az indikátor elindul)
int OnInit()
{
    // Nincs szükség bufferre a watermarkhoz
    ChartSetInteger(0, CHART_FOREGROUND, 0); // Biztosítja, hogy a watermark a háttérben maradjon
    return(INIT_SUCCEEDED);
}

// Watermark rajzoló funkció
void DrawWatermark()
{
    string symbol = Symbol();                // Az aktuális szimbólum lekérése (pl. XAU/USD)
    int timeframeSeconds = PeriodSeconds();  // Az aktuális időkeret lekérése másodpercben
    string timeframeText = "";

    // Az időkeret átalakítása olvasható formátumra másodpercek alapján
    switch(timeframeSeconds)
    {
        case 60: timeframeText = "1m"; break;
        case 300: timeframeText = "5m"; break;
        case 900: timeframeText = "15m"; break;
        case 1800: timeframeText = "30m"; break;
        case 3600: timeframeText = "1H"; break;
        case 14400: timeframeText = "4H"; break;
        case 86400: timeframeText = "1D"; break;
        case 604800: timeframeText = "1W"; break;
        case 2592000: timeframeText = "1M"; break;
        default: timeframeText = "Ismeretlen";
    }

    string WatermarkText = symbol + " " + timeframeText;  // Watermark szöveg létrehozása

    // Eltávolítja a régi objektumokat, hogy elkerülje a duplikálást
    ObjectDelete("WatermarkLabel");

    // Szöveg címke létrehozása
    ObjectCreate(0, "WatermarkLabel", OBJ_LABEL, 0, 0, 0);
    
    // A címke tulajdonságainak beállítása
    int xPos = (ChartGetInteger(0, CHART_WIDTH_IN_PIXELS) / 2) + XOffset;
    int yPos = (ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS) / 2) + YOffset;
    
    ObjectSetInteger(0, "WatermarkLabel", OBJPROP_XDISTANCE, xPos);
    ObjectSetInteger(0, "WatermarkLabel", OBJPROP_YDISTANCE, yPos);
    ObjectSetInteger(0, "WatermarkLabel", OBJPROP_COLOR, TextColor);
    ObjectSetInteger(0, "WatermarkLabel", OBJPROP_FONTSIZE, FontSize);
    ObjectSetString(0, "WatermarkLabel", OBJPROP_TEXT, WatermarkText);

    // Egyedi szöveg megjelenítése, ha engedélyezett
   if (ShowCustomText && CustomText != "")
   {
    ObjectDelete("CustomTextLabel");

    // Egyedi szöveg létrehozása és pozicionálása
    ObjectCreate(0, "CustomTextLabel", OBJ_LABEL, 0, 0, 0);
    int customXPos = CustomXOffset;
    int customYPos = CustomYOffset;

    ObjectSetInteger(0, "CustomTextLabel", OBJPROP_XDISTANCE, customXPos);
    ObjectSetInteger(0, "CustomTextLabel", OBJPROP_YDISTANCE, customYPos);
    ObjectSetInteger(0, "CustomTextLabel", OBJPROP_COLOR, CustomTextColor);
    ObjectSetInteger(0, "CustomTextLabel", OBJPROP_FONTSIZE, CustomFontSize);
    ObjectSetString(0, "CustomTextLabel", OBJPROP_TEXT, CustomText);
   }
}

// OnCalculate funkció (minden ticknél meghívódik)
int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[])
{
    // Watermark rajzolása minden ticknél
    DrawWatermark();
    return(rates_total);
}
