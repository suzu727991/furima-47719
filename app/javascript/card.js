const pay = () => {
  const publicKey = document.querySelector('meta[name="payjp-public-key"]')?.content;
  const form = document.getElementById("charge-form");
  if (!publicKey || !form) return;

  // Turboキャッシュ復帰時の二重マウントを防ぐ
  const numberElement = document.getElementById("number-form");
  if (numberElement.children.length > 0) return;

  const payjp = Payjp(publicKey);
  const elements = payjp.elements();
  const numberForm = elements.create("cardNumber");
  const expiryForm = elements.create("cardExpiry");
  const cvcForm = elements.create("cardCvc");
  numberForm.mount("#number-form");
  expiryForm.mount("#expiry-form");
  cvcForm.mount("#cvc-form");

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    payjp.createToken(numberForm).then((response) => {
      if (!response.error) {
        const tokenInput = document.createElement("input");
        tokenInput.type = "hidden";
        tokenInput.name = "token";
        tokenInput.value = response.id;
        form.appendChild(tokenInput);
      }
      numberForm.clear();
      expiryForm.clear();
      cvcForm.clear();
      form.submit();
    });
  });
};

document.addEventListener("turbo:load", pay);
document.addEventListener("turbo:render", pay);
