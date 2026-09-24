import axios, { AxiosError } from 'axios';
import dotenv from 'dotenv';

dotenv.config();

// ============================================================================
// TYPES & INTERFACES
// ============================================================================

export interface WhatsAppQuota {
  plan: string;
  dailyLimit: number;
  usedToday: number;
  dailyRemaining: number;
  resetsAt: string;
}

export interface WhatsAppResponse {
  ok: boolean;
  success: boolean;
  messageId: string;
  session: string;
  status: string;
  to: string;
  quota: WhatsAppQuota;
}

export interface WhatsAppError {
  error: string;
  code: string;
  retryAfter?: number;
  dailyLimit?: number;
  usedToday?: number;
  remaining?: number;
  resetsAt?: string;
}

export class WhatsAppAPIError extends Error {
  public code: string;
  public details: WhatsAppError;

  constructor(message: string, details: WhatsAppError) {
    super(message);
    this.name = 'WhatsAppAPIError';
    this.code = details.code;
    this.details = details;
  }
}

// ============================================================================
// CONSTANTS & CONFIG
// ============================================================================

const WHATSAPP_URL = process.env.WHATSAPP_URL || process.env.WHATSAPP_GATEWAY_URL;
const WHATSAPP_TOKEN = process.env.WHATSAPP_TOKEN || process.env.WHATSAPP_API_TOKEN;
const WHATSAPP_SESSION = process.env.WHATSAPP_SESSION || 'default';

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/**
 * Sanitizes phone numbers by removing spaces, plus signs, hyphens, and other non-digits.
 */
function sanitizePhone(phone: string): string {
  let normalized = phone.replace(/\D/g, '');
  // Strip leading zeros
  while (normalized.startsWith('0')) {
    normalized = normalized.substring(1);
  }
  // Assume Indian number if 10 digits
  if (normalized.length === 10) {
    normalized = `91${normalized}`;
  }
  return normalized;
}

/**
 * Base method for sending requests to the Gateway
 */
async function sendRequest(payload: any): Promise<WhatsAppResponse> {
  if (!WHATSAPP_URL || !WHATSAPP_TOKEN) {
    throw new Error('WhatsApp Gateway credentials are not configured properly in environment variables.');
  }

  // Inject session into every request
  const fullPayload = {
    session: WHATSAPP_SESSION,
    ...payload,
  };

  try {
    const response = await axios.post<WhatsAppResponse>(WHATSAPP_URL, fullPayload, {
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${WHATSAPP_TOKEN}`,
      },
    });

    return response.data;
  } catch (error) {
    if (axios.isAxiosError(error) && error.response) {
      const errData = error.response.data as WhatsAppError;
      throw new WhatsAppAPIError(errData.error || 'WhatsApp API request failed', errData);
    }
    throw error;
  }
}

// ============================================================================
// EXPORTED FEATURE FUNCTIONS
// ============================================================================

/**
 * Sends a standard text message.
 */
export async function sendWhatsAppMessage(phone: string, text: string): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    message: text,
  });
}

/**
 * Sends an image via URL or Base64.
 */
export async function sendImage(phone: string, imageUrl: string, caption?: string): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    attachment: { url: imageUrl, contentType: 'image/png' },
    ...(caption && { message: caption }),
  });
}

/**
 * Sends a Document / PDF.
 */
export async function sendDocument(phone: string, documentUrl: string, fileName: string, caption?: string): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    attachment: { url: documentUrl, contentType: 'application/pdf', fileName },
    ...(caption && { message: caption }),
  });
}

/**
 * Sends a Video.
 */
export async function sendVideo(phone: string, videoUrl: string, caption?: string): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    attachment: { url: videoUrl, contentType: 'video/mp4' },
    ...(caption && { message: caption }),
  });
}

/**
 * Sends an Audio/Voice note.
 */
export async function sendAudio(phone: string, audioUrl: string): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    attachment: { url: audioUrl, contentType: 'audio/mpeg' },
  });
}

/**
 * Sends a Location map card.
 */
export async function sendLocation(phone: string, lat: number, lng: number, name?: string, address?: string): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    location: {
      latitude: lat,
      longitude: lng,
      ...(name && { name }),
      ...(address && { address }),
    },
  });
}

/**
 * Sends a Contact (vCard).
 */
export async function sendContact(phone: string, fullName: string, contactPhone: string): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    contact: {
      fullName,
      phone: contactPhone,
    },
  });
}

/**
 * Sends an Interactive Poll.
 */
export async function sendPoll(phone: string, question: string, options: string[], selectableCount: number = 1): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    poll: {
      name: question,
      options,
      selectableCount,
    },
  });
}

/**
 * Sends a Reaction emoji to a specific message ID.
 */
export async function sendReaction(phone: string, emoji: string, messageId: string): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    reaction: {
      emoji,
      messageId,
    },
  });
}

/**
 * Replies to a specific quoted message ID.
 */
export async function sendReply(phone: string, text: string, quotedMessageId: string): Promise<WhatsAppResponse> {
  return sendRequest({
    phone: sanitizePhone(phone),
    message: text,
    quotedMessageId,
  });
}
