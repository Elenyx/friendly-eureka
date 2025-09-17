import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Link } from "wouter";
import { AlertCircle } from "lucide-react";

export default function NotFound() {
  return (
    <div className="w-full flex items-center justify-center py-24">
      <Card className="w-full max-w-lg mx-4 glass-effect border border-border">
        <CardContent className="pt-8">
          <div className="flex items-center gap-3 mb-3">
            <AlertCircle className="h-8 w-8 text-destructive" />
            <h1 className="text-2xl font-bold">404 Page Not Found</h1>
          </div>
          <p className="text-muted-foreground">
            The page you are looking for doesn't exist or has moved.
          </p>
          <div className="mt-6">
            <Link href="/">
              <Button className="btn-primary">Back to Home</Button>
            </Link>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}