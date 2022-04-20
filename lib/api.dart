// var domain = "http://192.168.0.116:5000";
// var domain = "https://quick-shop12.herokuapp.com";
var domain = "http://3.109.6.67:5000";

var endPoint = {
  'register': "/api/v1/auth/register",
  "login": "/api/v1/auth/login",
  "location": "/api/v1/auth/userLocation/",
  "nearShop": "/api/v1/shop/radius/",
  'fetchUser': '/api/v1/auth/fetchUser',
  'updateUser': '/api/v1/auth/updateUser',

  //CART
  'fetchUserCart': '/api/v1/cart/fetchUserCart',
  'insertIntoCart': '/api/v1/cart/insertIntoCart',
  'deleteFromCart': '/api/v1/cart/deleteFromCart',
  'updateCart': '/api/v1/cart/updateCart',
  'deleteCartProduct':'/api/v1/cart/deleteCartProduct',

  //ORDER
  'insertOrder': '/api/v1/order/insertOrder',
  'fetchUserOrder': '/api/v1/order/fetchUserOrder',
};
