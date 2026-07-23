import { corsHeaders } from "./cors.ts";

export class AppError extends Error {
  constructor(public statusCode: number, public message: string, public code: string) {
    super(message);
    this.name = 'AppError';
  }
}

export function handleError(error: unknown) {
  if (error instanceof AppError) {
    return new Response(JSON.stringify({ code: error.code, message: error.message }), {
      status: error.statusCode,
      headers: { 'Content-Type': 'application/json', ...corsHeaders },
    });
  }
  
  console.error("Unhandled error:", error);
  
  // if error has message property, log it
  if (error instanceof Error) {
    console.error(error.message);
  }

  return new Response(JSON.stringify({ code: 'INTERNAL_ERROR', message: 'Wystąpił nieoczekiwany błąd serwera.' }), {
    status: 500,
    headers: { 'Content-Type': 'application/json', ...corsHeaders },
  });
}
