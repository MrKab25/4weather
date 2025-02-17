document.addEventListener("DOMContentLoaded", getWeather);

async function getWeather() {
    const url = "https://api.open-meteo.com/v1/forecast?latitude=40.0456&longitude=-86.0086&hourly=temperature_2m,apparent_temperature,precipitation_probability,cloudcover&timezone=America/New_York";
    const container = document.getElementById("weather");
    
    container.innerHTML = `<p class="text-center text-gray-500">Fetching weather data...</p>`;

    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error("Weather data not available.");
        
        const data = await response.json();
        const forecast = extract4PMForecast(data);
        
        displayForecast(forecast);
    } catch (error) {
        container.innerHTML = `<p class="text-center text-red-500 font-bold">Error: ${error.message}</p>`;
    }
}

function extract4PMForecast(data) {
    const times = data.hourly.time;
    const temps = data.hourly.temperature_2m;
    const feelsLike = data.hourly.apparent_temperature;
    const precip = data.hourly.precipitation_probability;
    const clouds = data.hourly.cloudcover;

    let forecast = {};
    for (let i = 0; i < times.length; i++) {
        let [date, hour] = times[i].split("T");
        if (hour === "16:00") { // 4:00 PM
            forecast[date] = {
                temperature: temps[i],
                feelsLike: feelsLike[i],
                precipitation: precip[i],
                cloudCover: clouds[i]
            };
        }
    }
    return forecast;
}

function displayForecast(forecast) {
    const container = document.getElementById("weather");
    container.innerHTML = ""; // Clear previous data

    for (const [date, data] of Object.entries(forecast)) {
        container.innerHTML += `
            <div class="bg-blue-100 p-4 rounded-lg shadow-md mb-4">
                <p class="text-lg font-semibold text-gray-700">${formatDate(date)}</p>
                <p class="text-xl font-bold text-blue-700">🌡️ ${data.temperature}°F (Feels like: ${data.feelsLike}°F)</p>
                <p class="text-gray-600">☁️ Cloud Cover: <span class="font-semibold">${data.cloudCover}%</span></p>
                <p class="text-gray-600">🌧️ Precipitation: <span class="font-semibold">${data.precipitation}%</span></p>
            </div>
        `;
    }
}

function formatDate(dateStr) {
    const options = { weekday: "long", month: "short", day: "numeric" };
    return new Date(dateStr).toLocaleDateString("en-US", options);
}
