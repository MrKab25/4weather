async function getWeather() {
    const response = await fetch("https://api.open-meteo.com/v1/forecast?latitude=40.0456&longitude=-86.0086&hourly=temperature_2m,apparent_temperature,precipitation_probability,cloudcover&timezone=America/New_York");
    const data = await response.json();

    const times = data.hourly.time;
    const temps = data.hourly.temperature_2m;
    const feelsLike = data.hourly.apparent_temperature;
    const precip = data.hourly.precipitation_probability;
    const clouds = data.hourly.cloudcover;

    let forecast = {};
    for (let i = 0; i < times.length; i++) {
        let date = times[i].split("T")[0]; // Extract date
        let hour = times[i].split("T")[1]; // Extract time
        if (hour === "16:00") { // 4:00 PM
            forecast[date] = {
                temperature: temps[i],
                feelsLike: feelsLike[i],
                precipitation: precip[i],
                cloudCover: clouds[i]
            };
        }
    }

    console.log(forecast);
    displayForecast(forecast);
}

function displayForecast(forecast) {
    let container = document.getElementById("weather");
    container.innerHTML = "";
    for (const [date, data] of Object.entries(forecast)) {
        container.innerHTML += `<p>${date}: ${data.temperature}°F (Feels like: ${data.feelsLike}°F), Precip: ${data.precipitation}%, Clouds: ${data.cloudCover}%</p>`;
    }
}

getWeather();
