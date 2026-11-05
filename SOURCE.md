# Data Sources Proposal

## Proposal 1: Open-Meteo Weather Forecast API
1. **Description**: REST API המספק נתוני מזג אוויר היסטוריים ותחזיות עולמיות (טמפרטורה, לחות, משקעים, מהירות רוח) ברזולוציה שעתית לפי קואורדינטות גיאוגרפיות.
2. **URL**: https://open-meteo.com/en/docs
3. **Update Frequency**: מתעדכן מדי שעה בזמן אמת בהתאם למודלים מטאורולוגיים עולמיים.
4. **Expected Sample Size**: כ-24 עד 168 רשומות לכל קריאה (שבוע של נתונים שעתיים), נפח של כ-5KB עד 20KB בפורמט JSON.
5. **Authentication**: אין צורך במפתח (API Key) או בסיסמה לשימוש לא מסחרי – הגישה חופשית לחלוטין.
6. **Data Sample**:
```json
{
  "latitude": 32.08,
  "longitude": 34.78,
  "current_weather": {
    "temperature": 21.4,
    "windspeed": 12.5,
    "winddirection": 240,
    "weathercode": 1,
    "time": "2026-11-05T14:00"
  }
}
```

---

## Proposal 2: USGS Earthquake Hazards Program API
1. **Description**: שירות נתונים בזמן אמת של המכון הגיאולוגי של ארה"ב (USGS), המציג מידע על רעידות אדמה ברחבי העולם (מיקום, עומק ועוצמה בסולם ריכטר).
2. **URL**: https://earthquake.usgs.gov/fdsnws/event/1/
3. **Update Frequency**: מתעדכן ברציפות בזמן אמת בכל דקה עם זיהוי אירוע סייסמי חדש.
4. **Expected Sample Size**: כ-100 עד 300 אירועים ביממה ממוצעת, נפח של כ-100KB עד 500KB בפורמט GeoJSON.
5. **Authentication**: פתוח לחלוטין לציבור ללא צורך במפתח, הרשמה או סיסמה.
6. **Data Sample**:
```json
{
  "type": "Feature",
  "properties": {
    "mag": 4.5,
    "place": "12km ENE of Tokyo, Japan",
    "time": 1793880000000,
    "url": "[https://earthquake.usgs.gov/earthquakes/eventpage/us7000xxxx](https://earthquake.usgs.gov/earthquakes/eventpage/us7000xxxx)"
  },
  "geometry": {
    "type": "Point",
    "coordinates": [139.69, 35.68, 10.0]
  }
}
```

---

## Preferred Proposal
**ההצעה המועדפת:** הצעה 1 (Open-Meteo Weather Forecast API).
*נימוק:* המבנה של הנתונים אחיד וברור, אינו דורש הרשמה או ניהול טוקנים, ומאפשר ניתוחים סטטיסטיים מגוונים (כגון ממוצעים, חיזוי מגמות והשוואות בין ערים) המתאימים מאוד לדרישות הפרויקט בקורס.
