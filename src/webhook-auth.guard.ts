import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { Request } from 'express';

@Injectable()
export class WebhookAuthGuard implements CanActivate {
  private readonly secretToken = process.env.WEBHOOK_SECRET_TOKEN || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<Request>();
    const authHeader = request.headers.authorization;
    const xWebhookToken = request.headers['x-webhook-token'];

    // Check for Authorization header with Bearer token
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      if (token === this.secretToken) {
        return true;
      }
    }

    // Check for X-Webhook-Token header
    if (xWebhookToken && xWebhookToken === this.secretToken) {
      return true;
    }

    throw new UnauthorizedException('Invalid webhook authentication token');
  }
} 