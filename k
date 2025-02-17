<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weather App</title>

    <!-- Google Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <!-- Google Material Design Styles -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-components-web/14.0.0/material-components-web.min.css">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            color: #333;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            text-align: center;
        }

        footer {
            text-align: center;
            font-size: 0.8em;
            color: #666;
            margin-top: 20px;
        }

        .weather-card {
            background: white;
            margin: 15px 0;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .weather-card h3 {
            margin: 0;
            font-size: 1.5em;
        }

        .weather-card p {
            margin: 5px 0;
        }

        .weather-card .high-temp, .weather-card .low-temp {
            font-size: 1.2em;
            font-weight: 500;
        }

        .weather-card .time {
            font-size: 0.9em;
            color: #888;
        }

        @media (max-width: 600px) {
            .container {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>5-Day Weather Forecast</h1>
        </header>

        <section id="weather">
            <!-- Weather info will be injected here -->
        </section>
        
        <footer>
            <p>Weather data provided by Open-Meteo API</p>
        </footer>
    </div>

    <!-- Google Material Components Web -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/material-components-web/14.0.0/material-components-web.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const apiUrl = 'https://api.open-meteo.com/v1/forecast?latitude=40.0511&longitude=-85.7236&hourly=temperature_2m,apparent_temperature_2m,precipitation_hours&temperature_unit=fahrenheit&precipitation_unit=mm&timezone=America/New_York';
            const weatherSection = document.getElementById('weather');
            
            // Fetch weather data from Open-Meteo API
            fetch(apiUrl)
                .then(response => response.json())
                .then(data => {
                    displayWeather(data);
                })
                .catch(error => console.error('Error fetching weather data:', error));

            function displayWeather(data) {
                const hourly = data.hourly;

                let forecastHTML = '';

                // Loop over the next 5 days
                for (let i = 0; i < 5; i++) {
                    const day = hourly.slice(i * 24, (i + 1) * 24); // 24 hours per day
                    const dayHigh = Math.max(...day.map(hour => hour.temperature_2m));
                    const dayLow = Math.min(...day.map(hour => hour.temperature_2m));
                    const apparentHigh = Math.max(...day.map(hour => hour.apparent_temperature_2m));
                    const apparentLow = Math.min(...day.map(hour => hour.apparent_temperature_2m));

                    const highTime = day.find(hour => hour.temperature_2m === dayHigh);
                    const lowTime = day.find(hour => hour.temperature_2m === dayLow);
                    const highApparentTime = day.find(hour => hour.apparent_temperature_2m === apparentHigh);
                    const lowApparentTime = day.find(hour => hour.apparent_temperature_2m === apparentLow);

                    const precipitation = day.reduce((sum, hour) => sum + hour.precipitation_hours, 0);

                    forecastHTML += `
                        <div class="weather-card">
                            <h3>Day ${i + 1}</h3>
                            <p class="high-temp">High Temp: ${dayHigh}°F (Apparent: ${apparentHigh}°F)</p>
                            <p class="time">Time of High Temp: ${formatTime(highTime.time)} (Precipitation: ${precipitation} hours)</p>
                            <p class="low-temp">Low Temp: ${dayLow}°F (Apparent: ${apparentLow}°F)</p>
                            <p class="time">Time of Low Temp: ${formatTime(lowTime.time)} (Precipitation: ${precipitation} hours)</p>
                        </div>
                    `;
                }

                weatherSection.innerHTML = forecastHTML;
            }

            // Helper function to format time
            function formatTime(time) {
                const date = new Date(time * 1000); // Convert timestamp to milliseconds
                return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            }
        });
    </script>
</body>
</html>
