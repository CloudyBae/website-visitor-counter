document.addEventListener("DOMContentLoaded", function() {
    const api_url = "your api here";
    fetch(api_url)
      .then(response => response.json())
      .then(data => {
		console.log(data);
		const parsedData = JSON.parse(data.body);
        document.getElementById("pageviews").innerHTML = parsedData.Visit_Count;
      })
      .catch(error => console.error("Error fetching count:", error));
  });

// replace "pageviews" with your html item
