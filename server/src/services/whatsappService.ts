import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();

export const sendWhatsAppMessage = async (to: string, message: string) => {
  const gatewayUrl = process.env.WHATSAPP_GATEWAY_URL;
  const apiToken = process.env.WHATSAPP_API_TOKEN;
  const session = process.env.WHATSAPP_SESSION || 'default';

  if (!gatewayUrl || !apiToken) {
    console.warn('WhatsApp Gateway is not configured properly in .env');
    return;
  }

  // Normalize phone number (very basic, assuming Indian numbers without +)
  let normalized = to.replace(/\D/g, '');
  while (normalized.startsWith('0')) {
    normalized = normalized.substring(1);
  }
  if (normalized.length === 10) {
    normalized = '91' + normalized;
  }

  try {
    const url = `${gatewayUrl}/send-message`;
    await axios.post(
      url,
      { to: normalized, message },
      {
        params: { token: apiToken, session },
        headers: { 'Content-Type': 'application/json' },
      }
    );
    console.log('WhatsApp message sent successfully.');
  } catch (error: any) {
    console.error('WhatsApp API Error:', error.message);
  }
};
