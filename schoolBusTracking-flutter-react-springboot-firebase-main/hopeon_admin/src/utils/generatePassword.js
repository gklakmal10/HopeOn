export default function generatePassword(
  length = 12,
  options = {
    includeUppercase: true,
    includeNumbers: true,
    includeSpecialChars: true,
  }
) {
  const lowercaseChars = "abcdefghijklmnopqrstuvwxyz";
  const uppercaseChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const numberChars = "0123456789";
  const specialChars = "!@#$%^&*()_+-=[]{}|;:',.<>?";

  let characterPool = lowercaseChars;

  if (options.includeUppercase) {
    characterPool += uppercaseChars;
  }
  if (options.includeNumbers) {
    characterPool += numberChars;
  }
  if (options.includeSpecialChars) {
    characterPool += specialChars;
  }

  let password = "";
  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(Math.random() * characterPool.length);
    password += characterPool[randomIndex];
  }

  return password;
}
