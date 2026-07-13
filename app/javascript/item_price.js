const calculateProfit = () => {
  const priceInput = document.getElementById("item-price");
  if (!priceInput) return;

  priceInput.addEventListener("input", () => {
    const price = priceInput.value;
    const addTaxPrice = document.getElementById("add-tax-price");
    const profit = document.getElementById("profit");

    if (price === "") {
      addTaxPrice.innerHTML = "";
      profit.innerHTML = "";
      return;
    }

    const tax = Math.floor(price * 0.1);
    addTaxPrice.innerHTML = tax;
    profit.innerHTML = price - tax;
  });
};

document.addEventListener("turbo:load", calculateProfit);
document.addEventListener("turbo:render", calculateProfit);
